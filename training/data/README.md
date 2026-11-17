# Dataset (not redistributed)

Download the wrist-PPG + accelerometer + gyroscope treadmill dataset here:

    git clone https://github.com/hooseok/gyro_acc_ppg.git training/data/gyro_acc_ppg

It provides `Subject_1.mat` ... `Subject_24.mat` (PPG/ACC/Gyro at 50 Hz). The files are git-ignored.
Please cite: H. Lee, H. Chung and J. Lee, "Motion Artifact Cancellation in Wearable Photoplethysmography
Using Gyroscope," *IEEE Sensors Journal*, doi:10.1109/JSEN.2018.2879970.

The notebook `training/training_latency_vs_rate.ipynb` expects the folder as `gyro_acc_ppg/`; adjust the path in its first cells.
