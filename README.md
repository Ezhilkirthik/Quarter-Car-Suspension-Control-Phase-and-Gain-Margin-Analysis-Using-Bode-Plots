# 🚗 Quarter-Car Suspension Control  
### Passive vs Skyhook • Bode Plot Analysis • MATLAB and Simulink

This repository implements a quarter-car suspension in MATLAB and Simulink and compares a normal passive suspension with a Skyhook (semi-active) controller.  
A 1 cm road bump is used as input. The project reports time-domain comfort metrics (displacement, acceleration, suspension travel, settling) and frequency-domain behavior (Bode, Gain/Phase margins, modal frequencies & damping).

## ⭐ Key Features  
- Full quarter-car model (sprung/unsprung masses, suspension + tire spring/damper)  
- Passive vs Skyhook control comparison  
- Time-domain plots: zs, zu, suspension travel, body acceleration  
- Frequency-domain analysis: Bode plots, Gain & Phase margins, damping ratios  
- Easy to tune: change masses, stiffness, damping, c_sky, and road input  

## 📊 Results Summary

### Comfort & Time-Domain  
RMS body acceleration: Passive = 0.289 m/s² | Skyhook = 0.262 m/s² (9.2% improvement)  
Peak body acceleration: Passive = 2.061 m/s² | Skyhook = 1.882 m/s²  
Body settling time: Passive = 1.021 s | Skyhook = 1.011 s  
Max suspension travel: Passive = 0.0134 m | Skyhook = 0.0135 m  

### Frequency-Domain  
Passive: Gain Margin ≈ 7.85, Phase Margin ≈ 60.4°  
Skyhook: Gain Margin ≈ 8.079 (18.15 dB), Phase Margin ≈ 149.41°  

### Modal Damping  
Body mode: 0.21 → 0.70  
Wheel-hop mode: unchanged

## 🧠 Model Overview

Skyhook control law:  
u = -c_sky * dot(z_s)

System equations:  
ms*zs_ddot = -ks(zs - zu) - cs(zs_dot - zu_dot) + u  
mu*zu_ddot = ks(zs - zu) + cs(zs_dot - zu_dot) - kt(zu - zr) - ct(zu_dot - zr_dot) - u

## 🔧 Parameters  
Sprung mass = 300 kg  
Unsprung mass = 40 kg  
Suspension stiffness = 15000 N/m  
Suspension damping = 1000 Ns/m  
Tire stiffness = 200000 N/m  
Tire damping = 50 Ns/m  
Road bump = 0.01 m (1 cm)  
Simulation = 5 s, ODE45  

## 📂 Repository Structure  
-Simulink/  
-Matlab Manuscript/   
-Graphs/  
-Images/  
-params.mat  
-Project Summary Report.pdf  
-README.md  
-License

## 🚀 Getting Started

### 1) Requirements  
- MATLAB (R2022b+)  
- Simulink  
- Control System Toolbox

## 📬 Contact  
Author: **Ezhilkirthik M**  
Email id: ezhilkirthikm@gmail.com 
If this project helped you, please ⭐ star the repo!

## 📝 License  
MIT License
