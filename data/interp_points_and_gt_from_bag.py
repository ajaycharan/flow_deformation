#!/usr/bin/env python

import sys
import numpy as np
import rospy
import rosbag
from pprint import pprint
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from tf import transformations
import scipy.io as sio

def simil_from_odom(odom):

    S = []
    MAX_H = 10
    # g = lambda x: 3 * (x / MAX_H)
    g = lambda x: x

    for t in odom:    

        # extract
        pos = t[0]
        rot = t[1]
        # alpha = g(pos[2]) # scale with z
        alpha = 1

        # convert the similtude
        A = np.linalg.inv(transformations.quaternion_matrix(rot))
        A[:3, :3] = alpha * A[:3, :3]
        A[:3, -1] = pos

        # save
        S.append(A)

    return S

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

if __name__ == '__main__':

    if len(sys.argv) != 2:
        print 'Usage: '
        sys.exit()

    topic_list = ['/msf_core/pose']
    bag = rosbag.Bag(sys.argv[1], 'r')

    odom = []

    print 'Reading...'

    for topic, msg, t in bag.read_messages(topics=topic_list):

        if topic == topic_list[0]:
            slam_init = True
            p = np.zeros(3)
            p[0] = msg.pose.pose.position.x
            p[1] = msg.pose.pose.position.y
            p[2] = msg.pose.pose.position.z

            q = np.zeros(4)
            q[0] = msg.pose.pose.orientation.x
            q[1] = msg.pose.pose.orientation.y
            q[2] = msg.pose.pose.orientation.z
            q[3] = msg.pose.pose.orientation.w

            odom.append((p, q))

    bag.close()


    # downsample and crop
    odom = odom[::10][1:-70]

    # construct similitudes
    S = simil_from_odom(odom)
    print S[0]
    print S[-1]

    # unzip
    pos, rot = zip(*odom)
    pos = np.array(pos)

    # plot
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot(pos[:, 0], pos[:, 1], pos[:, 2], c='r', label='Visual-Inertial Navigation')
    ax.axis('equal')
    plt.show()

    # write data to files
    np.savetxt('odometry.dat', pos, delimiter='\t')
    sio.savemat('similtudes.mat', mdict={'similtudes':S}, oned_as='row')

