<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>Zenith Eternal | Singularity Edition</title>
    <style>
        :root {
            --p-accent: #818cf8;
            --p-accent-rgb: 129, 140, 248;
            --p-bg: #030307;
            --p-card: rgba(10, 10, 18, 0.95);
            --p-text: #ffffff;
            --p-text-dim: rgba(255, 255, 255, 0.5);
            --p-spring: cubic-bezier(0.15, 0.85, 0.35, 1);
            --glass: rgba(255, 255, 255, 0.04);
            --glass-border: rgba(255, 255, 255, 0.08);
            --glow: 0 0 20px rgba(var(--p-accent-rgb), 0.3);
            --anim-speed: 0.5s;
        }

        .light-mode {
            --p-bg: #f0f4f8;
            --p-card: rgba(255, 255, 255, 0.85);
            --p-text: #0f172a;
            --p-text-dim: rgba(15, 23, 42, 0.6);
            --glass: rgba(0, 0, 0, 0.04);
            --glass-border: rgba(0, 0, 0, 0.08);
            --glow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        /* --- FOUNDATION --- */
        * { box-sizing: border-box; -webkit-tap-highlight-color: transparent; user-select: none; }
        
        body, html { 
            margin: 0; padding: 0; width: 100%; height: 100%; 
            background: var(--p-bg); color: var(--p-text);
            font-family: 'Inter', -apple-system, system-ui, sans-serif;
            overflow: hidden; transition: background 0.8s ease;
        }

        canvas#neural-canvas {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            z-index: 0; pointer-events: none; opacity: 0.6;
        }

        /* --- STAGE & CARDS --- */
        #stage {
            position: relative; z-index: 10; width: 100vw; height: 100vh;
            display: flex; align-items: center; justify-content: center;
            perspective: 2000px;
        }

        .main-container {
            width: 92vw; max-width: 420px; height: 88vh;
            background: var(--p-card); border-radius: 50px;
            border: 1.5px solid var(--glass-border);
            backdrop-filter: blur(50px); -webkit-backdrop-filter: blur(50px);
            display: flex; flex-direction: column; position: relative;
            overflow: hidden; box-shadow: var(--glow);
            transform-style: preserve-3d; transition: transform 0.1s linear;
        }

        .main-container::after {
            content: ''; position: absolute; inset: 0;
            border-radius: 50px; border: 1px solid var(--p-accent);
            opacity: 0.3; pointer-events: none;
        }

        /* --- TOP NAV / HUD --- */
        .hud {
            padding: 30px 25px 0; display: flex; justify-content: space-between;
            align-items: center; z-index: 100; flex-shrink: 0;
        }

        .stat-cluster { display: flex; gap: 10px; }
        .hud-chip {
            background: rgba(0,0,0,0.4); border: 1px solid var(--glass-border);
            padding: 8px 14px; border-radius: 16px; font-size: 0.7rem;
            font-weight: 800; display: flex; align-items: center; gap: 6px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .settings-btn {
            width: 42px; height: 42px; border-radius: 14px;
            background: var(--glass); border: 1px solid var(--glass-border);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; cursor: pointer; transition: 0.3s;
        }
        .settings-btn:active { transform: scale(0.9) rotate(45deg); }

        /* --- MODE TOGGLE --- */
        .mode-selector {
            margin: 20px 25px 0; height: 50px; background: rgba(0,0,0,0.2);
            border-radius: 25px; padding: 5px; position: relative;
            display: flex; border: 1px solid var(--glass-border);
        }
        .glider {
            position: absolute; width: calc(50% - 5px); height: 40px;
            background: var(--p-accent); border-radius: 20px;
            transition: 0.6s var(--p-spring); box-shadow: 0 4px 15px rgba(var(--p-accent-rgb), 0.4);
        }
        .mode-tab {
            flex: 1; z-index: 5; display: flex; align-items: center;
            justify-content: center; font-size: 0.65rem; font-weight: 900;
            letter-spacing: 1.5px; transition: 0.3s; color: var(--p-text-dim);
        }
        .mode-tab.active { color: #fff; }

        /* --- VIEWPORTS --- */
        main { flex: 1; position: relative; overflow: hidden; margin-top: 10px; }
        .view {
            position: absolute; inset: 0; display: none;
            flex-direction: column; align-items: center;
            padding: 20px 25px 120px; overflow-y: scroll;
            -webkit-overflow-scrolling: touch;
        }
        .view.active { display: flex; animation: viewEnter 0.6s var(--p-spring) forwards; }
        @keyframes viewEnter {
            from { opacity: 0; transform: translateY(30px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        /* --- HOME ELEMENTS --- */
        .timer-wrap { margin: 40px 0; text-align: center; position: relative; }
        .timer-val {
            font-size: 4.5rem; font-weight: 900; letter-spacing: -3px;
            font-variant-numeric: tabular-nums; text-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .pulse { animation: pulseAnim 2s infinite ease-in-out; }
        @keyframes pulseAnim {
            0%, 100% { transform: scale(1); filter: brightness(1); }
            50% { transform: scale(1.03); filter: brightness(1.3); }
        }

        .xp-container { width: 100%; margin-bottom: 30px; }
        .xp-label {
            display: flex; justify-content: space-between; font-size: 0.6rem;
            font-weight: 900; color: var(--p-accent); text-transform: uppercase;
            margin-bottom: 8px; letter-spacing: 1px;
        }
        .xp-track { width: 100%; height: 8px; background: rgba(128,128,128,0.1); border-radius: 4px; overflow: hidden; }
        .xp-fill { width: 0%; height: 100%; background: var(--p-accent); transition: 1.5s var(--p-spring); box-shadow: 0 0 10px var(--p-accent); }

        .btn-group { width: 100%; display: flex; flex-direction: column; gap: 12px; }
        .action-btn {
            height: 65px; border-radius: 20px; border: 1px solid var(--glass-border);
            background: var(--glass); color: var(--p-text); font-size: 0.8rem;
            font-weight: 900; letter-spacing: 1px; cursor: pointer; transition: 0.3s var(--p-spring);
            display: flex; align-items: center; justify-content: center; gap: 10px;
        }
        .btn-main { background: var(--p-text); color: var(--p-bg); border: none; }
        .btn-main:active { transform: scale(0.95); filter: brightness(0.9); }

        /* --- CARDS & ITEMS --- */
        .item-card {
            width: 100%; background: var(--glass); border-radius: 24px;
            border: 1px solid var(--glass-border); padding: 20px;
            margin-bottom: 15px; display: flex; justify-content: space-between;
            align-items: center; transition: 0.3s;
        }
        .item-card:hover { background: rgba(255,255,255,0.06); border-color: var(--p-accent); }
        
        .item-info b { display: block; font-size: 0.9rem; margin-bottom: 4px; }
        .item-info span { font-size: 0.65rem; color: var(--p-text-dim); }

        .price-tag {
            background: #ffd700; color: #000; padding: 6px 12px;
            border-radius: 10px; font-size: 0.7rem; font-weight: 900;
        }

        /* --- FOOTER NAV --- */
        .bottom-nav {
            position: absolute; bottom: 30px; left: 25px; right: 25px;
            height: 75px; background: rgba(0,0,0,0.3); border-radius: 30px;
            backdrop-filter: blur(20px); border: 1px solid var(--glass-border);
            display: flex; justify-content: space-around; align-items: center; z-index: 100;
        }
        .nav-icon {
            font-size: 1.5rem; color: var(--p-text-dim); transition: 0.4s;
            cursor: pointer; width: 50px; height: 50px; display: flex;
            align-items: center; justify-content: center; border-radius: 15px;
        }
        .nav-icon.active { color: var(--p-accent); background: rgba(var(--p-accent-rgb), 0.1); }

        /* --- DRAWERS & MODALS --- */
        .drawer {
            position: absolute; bottom: -100%; left: 0; width: 100%; height: 95%;
            background: var(--p-bg); border-radius: 45px 45px 0 0; z-index: 500;
            transition: 0.7s var(--p-spring); padding: 40px 30px;
            border-top: 2px solid var(--p-accent); overflow-y: auto;
        }
        .drawer.open { bottom: 0; }
        .drawer-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        
        .grid-inputs { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; margin-bottom: 30px; }
        .time-box {
            background: var(--glass); border-radius: 20px; padding: 20px 10px;
            text-align: center; border: 1px solid var(--glass-border);
        }
        .time-box input {
            width: 100%; background: none; border: none; color: var(--p-text);
            font-size: 2rem; font-weight: 900; text-align: center;
        }
        .time-box span { font-size: 0.6rem; color: var(--p-accent); font-weight: 900; }

        #reflection-overlay {
            position: absolute; inset: 0; background: var(--p-bg);
            z-index: 1000; display: none; flex-direction: column;
            align-items: center; justify-content: center; text-align: center; padding: 40px;
        }

        /* --- CUSTOM SCROLLBAR --- */
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-thumb { background: var(--p-accent); border-radius: 10px; }

    </style>
</head>
<body>

    <canvas id="neural-canvas"></canvas>

    <div id="stage">
        <div class="main-container" id="main-container">
            
            <div id="reflection-overlay">
                <h1 style="letter-spacing: 5px;">SESSION END</h1>
                <p id="reward-text" style="color: var(--p-accent); font-weight: 900; margin-bottom: 40px;"></p>
                <div style="display: flex; gap: 20px;">
                    <div class="settings-btn" style="width:70px; height:70px; font-size:2.5rem;" onclick="Core.endSession('sad')">🙁</div>
                    <div class="settings-btn" style="width:70px; height:70px; font-size:2.5rem;" onclick="Core.endSession('mid')">😐</div>
                    <div class="settings-btn" style="width:70px; height:70px; font-size:2.5rem;" onclick="Core.endSession('happy')">😁</div>
                </div>
                <p style="margin-top: 30px; font-size: 0.6rem; opacity: 0.5;">HOW WAS YOUR NEURAL FLOW?</p>
            </div>

            <div class="hud">
                <div class="stat-cluster">
                    <div class="hud-chip">🔥 <span id="streak-val">0</span></div>
                    <div class="hud-chip">🪙 <span id="coin-val">0</span></div>
                </div>
                <div class="settings-btn" onclick="UI.toggleDrawer('settings', true)">⚙️</div>
            </div>

            <div class="mode-selector" onclick="Core.switchMode()">
                <div class="glider" id="mode-glider"></div>
                <div class="mode-tab active" id="mode-focus">FOCUS</div>
                <div class="mode-tab" id="mode-workout">WORKOUT</div>
            </div>

            <main>
                <section id="view-home" class="view active">
                    <div class="xp-container">
                        <div class="xp-label">
                            <span id="rank-name">NEURAL NOVICE</span>
                            <span>LVL <span id="lvl-val">1</span></span>
                        </div>
                        <div class="xp-track"><div class="xp-fill" id="xp-bar"></div></div>
                    </div>
                    
                    <div class="timer-wrap">
                        <div class="timer-val" id="timer-display">00:25:00</div>
                        <div id="status-tag" style="font-size: 0.6rem; letter-spacing: 3px; opacity: 0.4; font-weight: 900;">IDLE_SYSTEM</div>
                    </div>

                    <div class="btn-group">
                        <button class="action-btn btn-main" id="trigger-btn" onclick="Core.toggleTimer()">
                            <span>INITIATE SEQUENCE</span>
                        </button>
                        <button class="action-btn" onclick="UI.toggleDrawer('calibrate', true)">
                            <span>CALIBRATE TEMPORAL</span>
                        </button>
                    </div>
                </section>

                <section id="view-shop" class="view">
                    <h2 style="font-size: 0.8rem; letter-spacing: 2px; color: var(--p-accent); width: 100%;">NEURAL FORGE (BUFFS)</h2>
                    <div id="forge-list" style="width: 100%;">
                        </div>
                    
                    <h2 style="font-size: 0.8rem; letter-spacing: 2px; color: var(--p-accent); width: 100%; margin-top: 30px;">SKIN REPOSITORY</h2>
                    <div id="skin-list" style="width: 100%;">
                        </div>
                </section>

                <section id="view-stats" class="view">
                    <h2 style="font-size: 0.8rem; letter-spacing: 2px; color: var(--p-accent); width: 100%;">NEURAL ANALYTICS</h2>
                    <div class="item-card"><span>Total XP</span><b id="stat-xp">0</b></div>
                    <div class="item-card"><span>Sessions</span><b id="stat-sessions">0</b></div>
                    <div class="item-card"><span>Avg. Resonance</span><b id="stat-mood">NEUTRAL</b></div>
                    <div class="item-card"><span>Highest Streak</span><b id="stat-streak">0</b></div>
                </section>
            </main>

            <div class="bottom-nav">
                <div class="nav-icon active" onclick="UI.switchView('home', this)">⏱</div>
                <div class="nav-icon" onclick="UI.switchView('shop', this)">🛒</div>
                <div class="nav-icon" onclick="UI.switchView('stats', this)">📊</div>
            </div>

            <div class="drawer" id="drawer-calibrate">
                <div class="drawer-header">
                    <h3>CALIBRATION</h3>
                    <div class="settings-btn" onclick="UI.toggleDrawer('calibrate', false)">✕</div>
                </div>
                <div class="grid-inputs">
                    <div class="time-box"><span>HOURS</span><input type="number" id="in-h" value="0"></div>
                    <div class="time-box"><span>MINS</span><input type="number" id="in-m" value="25"></div>
                    <div class="time-box"><span>SECS</span><input type="number" id="in-s" value="0"></div>
                </div>
                <button class="action-btn btn-main" onclick="Core.applyCalibration()">APPLY TEMPORAL SHIFT</button>
            </div>

            <div class="drawer" id="drawer-settings">
                <div class="drawer-header">
                    <h3>SYSTEM</h3>
                    <div class="settings-btn" onclick="UI.toggleDrawer('settings', false)">✕</div>
                </div>
                <div class="item-card">
                    <span>Appearance</span>
                    <button class="action-btn" style="width: 100px; height: 35px; font-size: 0.6rem;" id="mode-btn" onclick="UI.toggleVisualMode()">DARK</button>
                </div>
                <div class="item-card">
                    <span>Neural Audio</span>
                    <button class="action-btn" style="width: 100px; height: 35px; font-size: 0.6rem;" id="audio-btn" onclick="UI.togglePref('audio')">ON</button>
                </div>
                <div class="item-card">
                    <span>Haptic Pulsing</span>
                    <button class="action-btn" style="width: 100px; height: 35px; font-size: 0.6rem;" id="haptic-btn" onclick="UI.togglePref('haptics')">ON</button>
                </div>
                <div class="item-card" style="border-color: #ef4444;">
                    <span style="color: #ef4444;">Erase Neural Memory</span>
                    <button class="action-btn" style="width: 80px; height: 35px; background: #ef4444; border: none; font-size: 0.5rem;" onclick="Data.wipe()">WIPE</button>
                </div>
            </div>

        </div>
    </div>

    <script>
        /**
         * ZENITH ETERNAL CORE ENGINE
         * Enhanced with Persistence for Background Timing
         */
        
        const AudioSfx = new (window.AudioContext || window.webkitAudioContext)();
        function beep(freq, duration, type = 'sine', volume = 0.1) {
            if (!State.db.audio) return;
            const osc = AudioSfx.createOscillator();
            const gain = AudioSfx.createGain();
            osc.type = type;
            osc.frequency.setValueAtTime(freq, AudioSfx.currentTime);
            gain.gain.setValueAtTime(volume, AudioSfx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.01, AudioSfx.currentTime + duration);
            osc.connect(gain);
            gain.connect(AudioSfx.destination);
            osc.start();
            osc.stop(AudioSfx.currentTime + duration);
        }

        const State = {
            active: false,
            mode: 'focus', 
            seconds: 1500,
            initialSeconds: 1500,
            timerId: null,
            alarmId: null,
            pendingXP: 0,
            db: JSON.parse(localStorage.getItem('zenith_v40')) || {
                xp: 0, coins: 1000, theme: 't_0', unlocked: ['t_0'],
                sessions: 0, moods: [], streak: 0, maxStreak: 0,
                audio: true, haptics: true, lightMode: false,
                buff_xp: 0, buff_magnet: false, buff_warp: false,
                // PERSISTENCE KEYS
                activeEndTime: null,
                savedSeconds: 1500
            }
        };

        const THEMES = Array.from({length: 102}, (_, i) => ({
            id: `t_${i}`,
            name: ["Slate", "Void", "Neon", "Crimson", "Emerald", "Gold", "Stardust", "Glitch", "Cosmos"][i % 9] + " " + (Math.floor(i/9)+1),
            price: i === 0 ? 0 : Math.floor(Math.pow(i, 1.8) * 100),
            color: `hsl(${(i * 137.5) % 360}, 70%, 60%)`,
            rarity: i < 20 ? 'COMMON' : i < 50 ? 'RARE' : i < 80 ? 'EPIC' : 'LEGENDARY'
        }));

        const FORGE = [
            { id: 'f_xp', name: 'XP Overload', desc: 'Next 3 sessions x3 XP', price: 15000, consumable: true },
            { id: 'f_mag', name: 'Wealth Sigil', desc: 'Permanent 2x coins', price: 100000, consumable: false },
            { id: 'f_warp', name: 'Time Warp', desc: '10% faster timer', price: 250000, consumable: false }
        ];

        const Core = {
            init() {
                UI.applyTheme(State.db.theme);
                UI.updateHUD();
                UI.renderLists();
                ParticleEngine.start();
                this.setupGyro();

                // BACKGROUND SYNC: Check if a timer was running when we closed the app
                if (State.db.activeEndTime) {
                    const now = Date.now();
                    const diff = Math.floor((State.db.activeEndTime - now) / 1000);
                    
                    if (diff > 0) {
                        State.seconds = diff;
                        this.start(true); // Resume timer
                    } else {
                        // Timer finished while app was closed
                        State.seconds = 0;
                        State.db.activeEndTime = null;
                        Data.save();
                        this.triggerAlarm();
                    }
                } else {
                    State.seconds = State.db.savedSeconds;
                    UI.updateTimerDisplay();
                }
            },

            setupGyro() {
                window.addEventListener('deviceorientation', (e) => {
                    if (!State.db.haptics) return;
                    const x = Math.min(Math.max(e.beta / 8, -10), 10);
                    const y = Math.min(Math.max(e.gamma / 8, -10), 10);
                    const container = document.getElementById('main-container');
                    if(container) container.style.transform = `rotateX(${-x}deg) rotateY(${y}deg)`;
                    ParticleEngine.tilt(y, x);
                });
            },

            toggleTimer() {
                if (State.active) {
                    this.stop();
                    beep(300, 0.2, 'sawtooth');
                } else {
                    this.start();
                    beep(800, 0.1);
                }
            },

            start(isResuming = false) {
                State.active = true;
                if (!isResuming) {
                    State.initialSeconds = State.seconds;
                    // CALCULATE END TIME FOR BACKGROUND
                    State.db.activeEndTime = Date.now() + (State.seconds * 1000);
                    Data.save();
                }
                
                document.getElementById('trigger-btn').innerHTML = "<span>ABORT SEQUENCE</span>";
                document.getElementById('timer-display').classList.add('pulse');
                document.getElementById('status-tag').innerText = State.mode === 'focus' ? 'NEURAL_FLOW_ACTIVE' : 'PHYSICAL_STRAIN_ACTIVE';
                
                clearInterval(State.timerId);
                State.timerId = setInterval(() => this.tick(), 1000);
            },

            stop() {
                State.active = false;
                State.db.activeEndTime = null; // Clear background timer
                State.db.savedSeconds = State.seconds;
                Data.save();

                clearInterval(State.timerId);
                document.getElementById('trigger-btn').innerHTML = "<span>INITIATE SEQUENCE</span>";
                document.getElementById('timer-display').classList.remove('pulse');
                document.getElementById('status-tag').innerText = 'IDLE_SYSTEM';
            },

            tick() {
                if (State.mode === 'workout') {
                    State.seconds++;
                } else {
                    // Accurate Sync Check
                    const now = Date.now();
                    const remaining = Math.max(0, Math.floor((State.db.activeEndTime - now) / 1000));
                    State.seconds = remaining;

                    if (State.seconds <= 0) {
                        return this.triggerAlarm();
                    }
                }
                UI.updateTimerDisplay();
            },

            triggerAlarm() {
                this.stop();
                State.db.activeEndTime = null;
                Data.save();

                State.alarmId = setInterval(() => {
                    beep(1200, 0.1, 'square', 0.2);
                    setTimeout(() => beep(1000, 0.1, 'square', 0.2), 150);
                }, 1000);
                
                const base = Math.floor(State.initialSeconds / 60) * 25 + 50;
                let multiplier = 1;
                if (State.db.buff_xp > 0) { multiplier = 3; State.db.buff_xp--; }
                
                State.pendingXP = base * multiplier;
                document.getElementById('reward-text').innerText = `+${State.pendingXP} XP GENERATED`;
                document.getElementById('reflection-overlay').style.display = 'flex';
            },

            endSession(mood) {
                clearInterval(State.alarmId);
                State.db.xp += State.pendingXP;
                
                let coinGain = Math.floor(State.pendingXP / 2);
                if (State.db.buff_magnet) coinGain *= 2;
                
                State.db.coins += coinGain;
                State.db.sessions++;
                State.db.moods.push(mood);
                
                State.db.streak++;
                if (State.db.streak > State.db.maxStreak) State.db.maxStreak = State.db.streak;

                State.seconds = State.mode === 'focus' ? 1500 : 0;
                State.db.savedSeconds = State.seconds;
                
                Data.save();
                document.getElementById('reflection-overlay').style.display = 'none';
                UI.updateHUD();
                UI.updateTimerDisplay();
            },

            switchMode() {
                if (State.active) return;
                State.mode = State.mode === 'focus' ? 'workout' : 'focus';
                const glider = document.getElementById('mode-glider');
                glider.style.transform = State.mode === 'workout' ? 'translateX(100%)' : 'translateX(0)';
                
                document.getElementById('mode-focus').classList.toggle('active', State.mode === 'focus');
                document.getElementById('mode-workout').classList.toggle('active', State.mode === 'workout');
                
                State.seconds = State.mode === 'focus' ? 1500 : 0;
                State.db.savedSeconds = State.seconds;
                Data.save();
                
                UI.updateTimerDisplay();
                beep(500, 0.05);
            },

            applyCalibration() {
                const h = parseInt(document.getElementById('in-h').value) || 0;
                const m = parseInt(document.getElementById('in-m').value) || 0;
                const s = parseInt(document.getElementById('in-s').value) || 0;
                State.seconds = (h * 3600) + (m * 60) + s;
                State.db.savedSeconds = State.seconds;
                Data.save();
                
                UI.updateTimerDisplay();
                UI.toggleDrawer('calibrate', false);
                beep(900, 0.1);
            }
        };

        const UI = {
            updateTimerDisplay() {
                const s = Math.abs(State.seconds);
                const hrs = Math.floor(s / 3600).toString().padStart(2, '0');
                const min = Math.floor((s % 3600) / 60).toString().padStart(2, '0');
                const sec = (s % 60).toString().padStart(2, '0');
                document.getElementById('timer-display').innerText = `${hrs}:${min}:${sec}`;
            },

            updateHUD() {
                document.getElementById('streak-val').innerText = State.db.streak;
                document.getElementById('coin-val').innerText = State.db.coins.toLocaleString();
                document.getElementById('lvl-val').innerText = Math.floor(State.db.xp / 500) + 1;
                document.getElementById('xp-bar').style.width = (State.db.xp % 500) / 5 + "%";
                
                document.getElementById('stat-xp').innerText = State.db.xp.toLocaleString();
                document.getElementById('stat-sessions').innerText = State.db.sessions;
                document.getElementById('stat-streak').innerText = State.db.maxStreak;
                
                if (State.db.moods.length) {
                    const mode = [...State.db.moods].sort((a,b) => 
                        State.db.moods.filter(v => v===a).length - State.db.moods.filter(v => v===b).length
                    ).pop();
                    document.getElementById('stat-mood').innerText = mode.toUpperCase();
                }

                document.getElementById('audio-btn').innerText = State.db.audio ? "ON" : "OFF";
                document.getElementById('haptic-btn').innerText = State.db.haptics ? "ON" : "OFF";
                document.getElementById('mode-btn').innerText = State.db.lightMode ? "LIGHT" : "DARK";
            },

            renderLists() {
                const skinList = document.getElementById('skin-list');
                skinList.innerHTML = THEMES.map(t => {
                    const isOwned = State.db.unlocked.includes(t.id);
                    const isActive = State.db.theme === t.id;
                    return `
                        <div class="item-card">
                            <div class="item-info">
                                <span style="color: ${t.color}; font-size: 0.5rem; font-weight: 900;">${t.rarity}</span>
                                <b>${t.name}</b>
                                <span>${isOwned ? 'Neural Surface Cached' : '🪙 ' + t.price.toLocaleString()}</span>
                            </div>
                            <button class="action-btn" style="width: 80px; height: 35px; font-size: 0.6rem; background: ${isActive ? t.color : (isOwned ? 'var(--glass)' : '#fff')}; color: ${isOwned && !isActive ? '#fff' : '#000'}; border: none;" onclick="UI.buySkin('${t.id}', ${t.price})">
                                ${isActive ? 'ACTIVE' : (isOwned ? 'USE' : 'BUY')}
                            </button>
                        </div>
                    `;
                }).join('');

                const forgeList = document.getElementById('forge-list');
                forgeList.innerHTML = FORGE.map(f => {
                    const hasPerm = (f.id === 'f_mag' && State.db.buff_magnet) || (f.id === 'f_warp' && State.db.buff_warp);
                    return `
                        <div class="item-card">
                            <div class="item-info">
                                <b>${f.name}</b>
                                <span>${f.desc}</span>
                            </div>
                            <button class="action-btn" style="width: 80px; height: 35px; font-size: 0.6rem; border: none; background: ${hasPerm ? 'var(--p-accent)' : '#fff'}; color: #000;" onclick="UI.buyForge('${f.id}', ${f.price})">
                                ${hasPerm ? 'OWNED' : '🪙 ' + (f.price/1000) + 'K'}
                            </button>
                        </div>
                    `;
                }).join('');
            },

            buySkin(id, price) {
                if (State.db.unlocked.includes(id)) {
                    this.applyTheme(id);
                } else if (State.db.coins >= price) {
                    State.db.coins -= price;
                    State.db.unlocked.push(id);
                    this.applyTheme(id);
                    beep(1000, 0.2);
                }
                Data.save(); this.updateHUD(); this.renderLists();
            },

            buyForge(id, price) {
                if (State.db.coins < price) return;
                if (id === 'f_xp') { State.db.buff_xp += 3; State.db.coins -= price; }
                if (id === 'f_mag' && !State.db.buff_magnet) { State.db.buff_magnet = true; State.db.coins -= price; }
                if (id === 'f_warp' && !State.db.buff_warp) { State.db.buff_warp = true; State.db.coins -= price; }
                beep(1200, 0.3, 'triangle');
                Data.save(); this.updateHUD(); this.renderLists();
            },

            applyTheme(id) {
                const theme = THEMES.find(t => t.id === id);
                document.documentElement.style.setProperty('--p-accent', theme.color);
                document.documentElement.style.setProperty('--p-accent-rgb', this.hexToRgb(theme.color));
                State.db.theme = id;
            },

            hexToRgb(hsl) {
                const match = hsl.match(/\d+/g);
                return match ? match.join(',') : '129, 140, 248';
            },

            switchView(v, el) {
                document.querySelectorAll('.nav-icon').forEach(n => n.classList.remove('active'));
                el.classList.add('active');
                document.querySelectorAll('.view').forEach(view => view.classList.remove('active'));
                document.getElementById(`view-${v}`).classList.add('active');
                beep(400, 0.05);
            },

            toggleDrawer(id, open) {
                document.getElementById(`drawer-${id}`).classList.toggle('open', open);
                beep(open ? 600 : 300, 0.1);
            },

            toggleVisualMode() {
                State.db.lightMode = !State.db.lightMode;
                document.body.classList.toggle('light-mode', State.db.lightMode);
                this.updateHUD(); Data.save();
            },

            togglePref(key) {
                State.db[key] = !State.db[key];
                this.updateHUD(); Data.save();
            }
        };

        const ParticleEngine = {
            canvas: document.getElementById('neural-canvas'),
            ctx: null,
            particles: [],
            tiltX: 0, tiltY: 0,

            start() {
                this.ctx = this.canvas.getContext('2d');
                this.resize();
                window.addEventListener('resize', () => this.resize());
                for(let i=0; i<40; i++) this.particles.push(this.createParticle());
                this.animate();
            },

            resize() {
                this.canvas.width = window.innerWidth;
                this.canvas.height = window.innerHeight;
            },

            createParticle() {
                return {
                    x: Math.random() * this.canvas.width,
                    y: Math.random() * this.canvas.height,
                    size: Math.random() * 3 + 1,
                    speedX: Math.random() * 1 - 0.5,
                    speedY: Math.random() * 1 - 0.5,
                    opacity: Math.random() * 0.5
                };
            },

            tilt(x, y) { this.tiltX = x; this.tiltY = y; },

            animate() {
                this.ctx.clearRect(0,0,this.canvas.width, this.canvas.height);
                const color = getComputedStyle(document.documentElement).getPropertyValue('--p-accent');
                
                this.particles.forEach(p => {
                    p.x += p.speedX + (this.tiltX * 0.1);
                    p.y += p.speedY + (this.tiltY * 0.1);

                    if(p.x < 0) p.x = this.canvas.width;
                    if(p.x > this.canvas.width) p.x = 0;
                    if(p.y < 0) p.y = this.canvas.height;
                    if(p.y > this.canvas.height) p.y = 0;

                    this.ctx.beginPath();
                    this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                    this.ctx.fillStyle = color;
                    this.ctx.globalAlpha = p.opacity;
                    this.ctx.fill();
                });
                requestAnimationFrame(() => this.animate());
            }
        };

        const Data = {
            save() { localStorage.setItem('zenith_v40', JSON.stringify(State.db)); },
            wipe() { if(confirm("This will permanently delete your neural progress. Proceed?")) { localStorage.clear(); location.reload(); } }
        };

        // Initialize Core on Load
        window.onload = () => {
            Core.init();
            if(State.db.lightMode) document.body.classList.add('light-mode');
        };
    </script>
</body>
</html>
