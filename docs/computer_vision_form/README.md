# Adaptive Computer Vision Loop (Pose Estimation & Form-Checking)

## 1. Overview & Architectural Role
The **Adaptive Computer Vision Loop** provides real-time, deterministic, 100% on-device joint angle analysis and live biomechanical coaching cues during dynamic resistance training movements.
By tracking 2D keypoint joint vertices (Knee, Hip, Ankle, Elbow, Shoulder, Spine) at 60 FPS directly within device memory, FitKarma delivers instant audible and visual feedback without latency, network dependency, or video privacy risks.

---

## 2. Mathematical Kinematic Models & Deterministic Formulation

### 2.1 2D Joint Angle Trigonometry
Given three 2D keypoint coordinates $A(x_a, y_a)$, $B(x_b, y_b)$, and $C(x_c, y_c)$ where $B$ serves as the vertex joint:
$$\theta = \left| \operatorname{atan2}(y_c - y_b, x_c - x_b) - \operatorname{atan2}(y_a - y_b, x_a - x_b) \right| \times \frac{180^\circ}{\pi}$$
$$\text{If } \theta > 180^\circ \implies \theta = 360^\circ - \theta$$

### 2.2 Movement Phase State Machine
For resistance exercises, the state transitions through a finite set of deterministic phases:
1. **Setup ($\theta \ge 160^\circ$)**: Initial lockout and standing brace.
2. **Eccentric ($105^\circ < \theta < 160^\circ$)**: Controlled descent (target tempo $\ge 2.0\text{s}$).
3. **Peak Contraction / Depth ($\theta \le 95^\circ$)**: Full depth (optimal $\le 90^\circ$ for squats below parallel).
4. **Concentric ($95^\circ < \theta < 160^\circ$)**: Explosive ascent and drive.
5. **Lockout ($\theta \ge 160^\circ$)**: End of repetition with glute/scapular engagement.

### 2.3 Biomechanical Safety & Fault Detection
- **Squats / Baithak**:
  - *Optimal Depth*: Knee angle $\le 90^\circ$.
  - *Torso Pitch Fault*: Hip angle $< 45^\circ$ triggers instant alert (`छाती अत्यधिक आगे झुक रही है! सीना तानें`).
- **Bench Press / Desi Dand**:
  - *Elbow Flare Guard*: Shoulder abduction $> 85^\circ$ flags warning (`कोहनी ज्यादा चौड़ी फैल रही है! थोड़ा अंदर समेटें`).

---

## 3. Implementation Details

| Layer | File Path | Responsibilities |
| :--- | :--- | :--- |
| **Domain** | [`computer_vision_form_engine.dart`](file:///f:/fitkarma/lib/features/workout/domain/computer_vision_form_engine.dart) | Pure Dart 2D vector mathematics, joint angle calculation, state machine phases, and bilingual biomechanical cue generation. |
| **Presentation** | [`computer_vision_form_screen.dart`](file:///f:/fitkarma/lib/features/workout/presentation/computer_vision_form_screen.dart) | Bento UI with CustomPaint skeleton canvas simulator, phase indicator pills, real-time feedback HUD, and rep ledger. |

---

## 4. Privacy & Edge Security
- **100% In-Memory Processing**: Video frames and raw coordinates never persist or transmit over the network.
- **Zero Cloud Payload**: No Firestore or Firebase Storage rules required as analysis is strictly ephemeral on-device.

---

## 5. Verification & Lint Compliance
- Static analysis executed via `flutter analyze` with 0 warnings or errors.
- Verified offline without network connectivity.
