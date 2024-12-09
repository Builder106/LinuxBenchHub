# Ubuntu Benchmark Results

This document provides detailed benchmarking results for Ubuntu 24.04 running in a VMware Fusion Pro 13.6.1 virtual machine. The benchmarks were conducted using the Phoronix Test Suite.

## System Information

#### Hardware
- **Processor**: 2 x Intel Core i5-7360U (3 Cores)
- **Motherboard**: Intel VMware Virtual 440BX Desktop (6.00 BIOS)
- **Chipset**: Intel 440BX/ZX/DX
- **Memory**: 4096MB
- **Disk**: 21GB VMware Virtual S
- **Graphics**: VMware SVGA II
- **Audio**: Ensoniq ES1371/ES1373
- **Network**: Intel 82545EM

#### Software
- **OS**: Ubuntu 24.04
- **Kernel**: 6.8.0-49-generic (x86_64)
- **Desktop**: GNOME Shell 46.0
- **Display Server**: X Server 1.21.1.11 + Wayland
- **Compiler**: GCC 13.2.0
- **File-System**: ext4
- **Screen Resolution**: 1280x800
- **System Layer**: VMware
- **Timestamp**: 2024-12-07 14:28:03

---

## Test Results: C-Ray Benchmark

### Test Identifier: `pts/c-ray-2.0.0`

#### Title: C-Ray
- **App Version**: 2.0
- **Arguments**: `-s 1920x1080 -r 16`
- **Description**: Resolution: 1080p - Rays Per Pixel: 16
- **Scale**: Seconds
- **Display Format**: BAR_GRAPH

---

### Data Entries
- **Identifier**: CPU
- **Value (Seconds)**: 1077.898
- **Raw String (Milliseconds)**: `1244.257:767.61:869.845:1156.015:1447.948:1055.703:1221.001:1141.11:797.595`

---

### Detailed Run Times

| Run | Time (ms) |
|-----|-----------|
| 1   | 1244.257  |
| 2   | 767.610   |
| 3   | 869.845   |
| 4   | 1156.015  |
| 5   | 1447.948  |
| 6   | 1055.703  |
| 7   | 1221.001  |
| 8   | 1141.110  |
| 9   | 797.595   |

---

### Visualization
![C_Ray_Benchmark_Run_Times](https://github.com/user-attachments/assets/202c6ef4-b896-4725-92e6-de4f519be938)

## Test Results: Tinymembench Benchmark

### Test Identifier: `pts/tinymembench-1.0.2`

#### Title: Tinymembench
- **App Version**: 2018-05-28
- **Arguments**: 
- **Description**: Standard Memcpy
- **Scale**: MB/s
- **Display Format**: BAR_GRAPH

---

### Data Entries
- **Identifier**: Memory
- **Value (MB/s)**: 10954.1
- **Raw String (MB/s)**: `12877:10401.1:7507.6:11873.6:14624.8:13755.6:12553.1:7012.8:7981.4`

---

### Detailed Run Values

| Run | Value (MB/s) |
|-----|--------------|
| 1   | 12877.0      |
| 2   | 10401.1      |
| 3   | 7507.6       |
| 4   | 11873.6      |
| 5   | 14624.8      |
| 6   | 13755.6      |
| 7   | 12553.1      |
| 8   | 7012.8       |
| 9   | 7981.4       |

---

### Visualization
![Memcpy_Run_Values](https://github.com/user-attachments/assets/21a0ac94-f4f1-49f3-bf13-70b6e4069b1a)

---

### Test Identifier: `pts/tinymembench-1.0.2`

#### Title: Tinymembench
- **App Version**: 2018-05-28
- **Arguments**: 
- **Description**: Standard Memset
- **Scale**: MB/s
- **Display Format**: BAR_GRAPH

---

### Data Entries
- **Identifier**: Memory
- **Value (MB/s)**: 23384.6
- **Raw String (MB/s)**: `24886.8:17003.6:26430.7:26789.2:28912:27771:25745.6:22781.9:10140.9`

---

### Detailed Run Values

| Run | Value (MB/s) |
|-----|--------------|
| 1   | 24886.8      |
| 2   | 17003.6      |
| 3   | 26430.7      |
| 4   | 26789.2      |
| 5   | 28912.0      |
| 6   | 27771.0      |
| 7   | 25745.6      |
| 8   | 22781.9      |
| 9   | 10140.9      |

---

### Visualization
![Memset_Run_Values](https://github.com/user-attachments/assets/ed1b7294-cda9-4a1d-9e90-99932f424fd4)

---

## Test Results: Aircrack-ng Benchmark

### Test Identifier: `pts/aircrack-ng-1.3.0`

#### Title: Aircrack-ng
- **App Version**: 1.7
- **Arguments**: 
- **Description**: 
- **Scale**: k/s
- **Display Format**: BAR_GRAPH

---

### Data Entries
- **Identifier**: Network
- **Value (k/s)**: 4552.572
- **Raw String (k/s)**: `3586.451:3547.826:4794.453:3886.79:4744.814:5381.628:5432.095:5332.297:5380.734:5322.643:5330.558:3547.051:4225.79:2832.371:4943.083`

---

### Detailed Run Values

| Run | Value (k/s) |
|-----|-------------|
| 1   | 3586.451    |
| 2   | 3547.826    |
| 3   | 4794.453    |
| 4   | 3886.790    |
| 5   | 4744.814    |
| 6   | 5381.628    |
| 7   | 5432.095    |
| 8   | 5332.297    |
| 9   | 5380.734    |
| 10  | 5322.643    |
| 11  | 5330.558    |
| 12  | 3547.051    |
| 13  | 4225.790    |
| 14  | 2832.371    |
| 15  | 4943.083    |

---

### Visualization
![Aircrack_ng_Run_Values](https://github.com/user-attachments/assets/96df754c-c4e1-46c4-b2b3-542e5a6e6563)
