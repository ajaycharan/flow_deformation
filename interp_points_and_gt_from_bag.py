#!/usr/bin/env python

import sys
import numpy as np
import rospy
import rosbag
from pprint import pprint
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def align_3d(vo_pos, gt_pos):

    # choose ids to match dimensionality
    ids = np.round(np.linspace(0, len(gt_pos)-1, num=len(vo_pos)))
    ids = np.array(ids, dtype=np.int32)
    gt_pos = gt_pos[ids]

    # crop again for least squares
    vo_pos = vo_pos[::5]
    gt_pos = gt_pos[::5]

    # build A matrix
    dim = len(vo_pos)
    A = np.zeros((3*dim, 12))
    for i in range(0, dim):
        A[3*i    ,  0] =  vo_pos[i, 0]
        A[3*i    ,  1] =  vo_pos[i, 1]
        A[3*i    ,  2] =  vo_pos[i, 2]
        A[3*i    ,  9] =  1
        A[3*i + 1,  3] =  vo_pos[i, 0]
        A[3*i + 1,  4] =  vo_pos[i, 1]
        A[3*i + 1,  5] =  vo_pos[i, 2]
        A[3*i + 1, 10] =  1
        A[3*i + 2,  6] =  vo_pos[i, 0]
        A[3*i + 2,  7] =  vo_pos[i, 1]
        A[3*i + 2,  8] =  vo_pos[i, 2]
        A[3*i + 2, 11] =  1

    # build b
    b = np.reshape(gt_pos, 3*dim)

    # compute least squares
    x, r, rank, s = np.linalg.lstsq(A, b)

    # build transform
    R = np.array([x[:3], x[3:6], x[6:9]])
    t = x[9:]

    # SVD to fix R characteristics
    U, S, V = np.linalg.svd(R)
    R = np.dot(U, np.dot(np.eye(3), V))

    # rotate vo points
    vo_pos = np.dot(R, vo_pos.T).T

    # translate vo points
    vo_pos = vo_pos + np.reshape(np.tile(t, len(vo_pos)), vo_pos.shape)

    # compute mean squared error
    err = np.linalg.norm(gt_pos - vo_pos, axis=1)
    mse = np.dot(err, err) / dim
    me = np.mean(err)
    print 'Mean Squared Error: ' + str(mse)
    print 'Mean Error: ' + str(me)


    return vo_pos, gt_pos

# consider extending to 3d
def align_2d(vo_pos, gt_pos):

    # remove z
    vo_pos = vo_pos[:, :2]
    gt_pos = gt_pos[:, :2]
    
    # choose ids to match dimensionality
    ids = np.round(np.linspace(0, len(gt_pos)-1, num=len(vo_pos)))
    ids = np.array(ids, dtype=np.int32)
    gt_pos = gt_pos[ids]

    # crop again for least squares
    vo_pos = vo_pos[::5]
    gt_pos = gt_pos[::5]

    # build A matrix
    dim = len(vo_pos)
    A = np.zeros((2*dim, 6))
    for i in range(0, dim):
        A[2*i    , 0] =  vo_pos[i, 0]
        A[2*i    , 1] =  vo_pos[i, 1]
        A[2*i    , 4] =  1
        A[2*i + 1, 2] =  vo_pos[i, 0]
        A[2*i + 1, 3] =  vo_pos[i, 1]
        A[2*i + 1, 5] =  1

    # build b
    b = np.reshape(gt_pos, 2*dim)

    # compute least squares
    x, r, rank, s = np.linalg.lstsq(A, b)

    # build transform
    R = np.array([x[:2], x[2:4]])
    t = x[4:]

    # SVD to fix R characteristics
    U, S, V = np.linalg.svd(R)
    R = np.dot(U, np.dot(np.eye(2), V))

    # rotate vo points
    vo_pos = np.dot(R, vo_pos.T).T

    # translate vo points
    vo_pos = vo_pos + np.reshape(np.tile(t, len(vo_pos)), vo_pos.shape)

    return vo_pos, gt_pos

def plot_3d(vo_pos, gt_pos):
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot(vo_pos[:, 0], vo_pos[:, 1], vo_pos[:, 2], c='r', label='Visual-Inertial Navigation')
    ax.plot(gt_pos[:, 0], gt_pos[:, 1], gt_pos[:, 2], c='blue', label='Ground Truth')
    ax.axis('equal')
    plt.xlabel('meters')
    plt.ylabel('meters')
    plt.legend()
    plt.show()

def plot_2d(vo_pos, gt_pos):
    fig, ax = plt.subplots()
    # ax.scatter(vo_pos[:, 0], vo_pos[:, 1], c='r')
    # ax.scatter(gt_pos[:, 0], gt_pos[:, 1], c='blue')
    ax.plot(vo_pos[:, 0], vo_pos[:, 1], c='r')
    ax.plot(gt_pos[:, 0], gt_pos[:, 1], c='blue')

    ax.axis('equal')
    plt.show()

if __name__ == '__main__':

    if len(sys.argv) != 2:
        print 'Usage: '
        sys.exit()

    topic_list = ['/msf_core/pose',
            '/quadcloud2/odom']
    bag = rosbag.Bag(sys.argv[1], 'r')

    vo_pos = []
    vo_rot = []
    gt_pos = []
    gt_rot = []
    slam_init = False

    print 'Reading...'

    for topic, msg, t in bag.read_messages(topics=topic_list):

        if topic == topic_list[0]:
            slam_init = True
            t = np.zeros(3)
            t[0] = msg.pose.pose.position.x
            t[1] = msg.pose.pose.position.y
            t[2] = msg.pose.pose.position.z
            vo_pos.append(t)

            q = np.zeros(4)
            q[0] = msg.pose.pose.orientation.x
            q[1] = msg.pose.pose.orientation.y
            q[2] = msg.pose.pose.orientation.z
            q[3] = msg.pose.pose.orientation.w
            vo_rot.append(q)

        elif topic == topic_list[1] and slam_init:
            t = np.zeros(3)
            t[0] = msg.pose.pose.position.x
            t[1] = msg.pose.pose.position.y
            t[2] = msg.pose.pose.position.z
            gt_pos.append(t)

            q = np.zeros(4)
            q[0] = msg.pose.pose.orientation.x
            q[1] = msg.pose.pose.orientation.y
            q[2] = msg.pose.pose.orientation.z
            q[3] = msg.pose.pose.orientation.w
            gt_rot.append(q)

    bag.close()
    
    vo_pos = np.array(vo_pos)
    vo_rot = np.array(vo_rot)
    gt_pos = np.array(gt_pos)
    gt_rot = np.array(gt_rot)

    # downsample and crop
    # TODO: Consider a method to cluster and smooth
    vo_pos = vo_pos[::10][1:-70]
    gt_pos = gt_pos[:-30]

    # align with ground truth
    print 'Aligning...'
    vo_pos, gt_pos = align_3d(vo_pos, gt_pos)

    # plot
    plot_3d(vo_pos, gt_pos)
    # plot_2d(vo_pos[:,:2], gt_pos[:,:2])

    # write data to files
    np.savetxt('odom.dat', vo_pos, delimiter='\t')

