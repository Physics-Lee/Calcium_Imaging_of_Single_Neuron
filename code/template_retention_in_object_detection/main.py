import cv2
import numpy as np

import matplotlib
matplotlib.use('TkAgg')

import matplotlib.pyplot as plt

def align_images(template_img, target_img):
    # 初始化SIFT检测器
    sift = cv2.SIFT_create()
    
    # 使用SIFT找到关键点和描述符
    keypoints1, descriptors1 = sift.detectAndCompute(template_img, None)
    keypoints2, descriptors2 = sift.detectAndCompute(target_img, None)
    
    # 使用FLANN匹配器进行匹配
    FLANN_INDEX_KDTREE = 0
    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    
    flann = cv2.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(descriptors1, descriptors2, k=2)
    
    # 根据Lowe's比率测试存储良好的匹配
    good_matches = []
    for m, n in matches:
        if m.distance < 0.7*n.distance:
            good_matches.append(m)
    
    # 提取良好匹配的关键点位置
    src_pts = np.float32([keypoints1[m.queryIdx].pt for m in good_matches]).reshape(-1, 1, 2)
    dst_pts = np.float32([keypoints2[m.trainIdx].pt for m in good_matches]).reshape(-1, 1, 2)
    
    # 从匹配中计算单应性
    M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 5.0)
    
    # 使用单应性变换目标图像
    aligned_img = cv2.warpPerspective(target_img, M, (template_img.shape[1], template_img.shape[0]))
    
    return aligned_img

# 读取模板图像和目标图像
folder_path = r'F:/1_learning/research/taxis of C.elegans/Calcium Imaging/data/temp/'
template_image_path = folder_path + 'frame_004223.png'
template_image = cv2.imread(template_image_path, 0)
plt.imshow(template_image)
plt.show()
target_images_paths = [folder_path + 'frame_000001.png', folder_path + 'frame_000002.png', folder_path + 'frame_000003.png']

for target_image_path in target_images_paths:
    target_image = cv2.imread(target_image_path, 0)
    
    # 对齐图像
    aligned_image = align_images(template_image, target_image)
    
    # 在这里添加剪裁或填充逻辑
    
    # 保存或展示结果
    cv2.imshow('Aligned Image', aligned_image)
    cv2.waitKey(0)

cv2.destroyAllWindows()