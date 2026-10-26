function app = SmartDeskApp()
% SMARTDESKAPP  AI Smart Desk System - full UI rebuild (MATLAB R2023a+)
% Rebuilds the 7-page smart desk control panel (A-G) as a programmatic
% uifigure app. Run:  >> SmartDeskApp
% No toolboxes required.

app = struct();
app.hRec = []; app.hSynth = []; app.hListening = false; app.hSimMode = false;

% ---------- color palette (from original app) ----------
C.bg      = '#0F1219';   % window background
C.panel   = '#161A24';   % panel background
C.border  = '#3A4152';   % panel border
C.title   = '#FFFFFF';   % section titles
C.text    = '#E6EAF2';   % body text
C.dim     = '#9AA3B2';   % secondary text
C.cyan    = '#4FC3F7';   % data values / active
C.green   = '#4ADE80';   % ok / enabled
C.yellow  = '#FACC15';   % warning values
C.orange  = '#FFA500';
C.red     = '#F87171';   % danger
C.purple  = '#C084FC';
C.navOn   = '#2A5C82';   % active nav button
C.navOff  = '#1E2330';   % inactive nav button

% ---------- main figure ----------
app.fig = uifigure('Name','AI Smart Desk System', ...
    'Color',C.bg,'Position',[80 40 1280 840], ...
    'CloseRequestFcn',@(~,~)stopClock());

buildSidebar();
buildHeaderFooter();
buildAllPages();
darkTheme(app.fig);
switchPage(1);                          % start on page A
startClock();

    % ==================================================================
    function buildSidebar()
        uilabel(app.fig,'Text','AI Smart Desk System', ...
            'Position',[18 805 190 25],'FontColor',C.cyan, ...
            'FontSize',12,'FontWeight','bold','BackgroundColor',C.bg);

        names = {'A  Posture & Rhythm';'B  Adaptive Lighting'; ...
                 'C  Safety & Controls';'D  Environment'; ...
                 'E  Space & Objects';'F  Privacy';'G  Scene Switcher'; ...
                 'H  Voice Control'};
        app.navBtn = gobjects(8,1);
        for k = 1:8
            app.navBtn(k) = uibutton(app.fig,'push', ...
                'Text',names{k},'Tag',sprintf('nav%d',k), ...
                'Position',[15 790-k*72 195 60], ...
                'BackgroundColor',C.navOff,'FontColor',C.text, ...
                'FontSize',11,'FontWeight','bold');
            app.navBtn(k).ButtonPushedFcn = ...
                @(src,~)switchPage(str2double(src.Tag(4:end)));
        end

        uilabel(app.fig,'Text','SmartDesk Pro', ...
            'Position',[15 12 120 20],'FontColor',C.dim, ...
            'FontSize',9,'BackgroundColor',C.bg);
    end

    % ==================================================================
    function buildHeaderFooter()
        uilabel(app.fig,'Text','● System Running', ...
            'Position',[1120 808 150 22],'FontColor',C.green, ...
            'FontSize',11,'BackgroundColor',C.bg);
        uilabel(app.fig,'Text','[Local Storage] [Encrypted] [LAN]', ...
            'Position',[640 12 260 20],'FontColor',C.dim, ...
            'FontSize',9,'BackgroundColor',C.bg);
        app.clockLbl = uilabel(app.fig,'Text','00:00:00', ...
            'Position',[1200 12 70 20],'FontColor',C.dim, ...
            'FontSize',9,'BackgroundColor',C.bg);
    end

    % ==================================================================
    function buildAllPages()
        app.pages = cell(1,8);
        for k = 1:8
            app.pages{k} = uipanel(app.fig,'Position',[220 35 1045 795], ...
                'BackgroundColor',C.bg,'BorderColor',C.bg, ...
                'BorderType','none');
        end
        buildPageA(); buildPageB(); buildPageC(); buildPageD(); ...
        buildPageE(); buildPageF(); buildPageG(); buildPageH();
    end

    function p = mkPanel(page,pos,ttl)
        p = uipanel(app.pages{page},'Position',pos, ...
            'BackgroundColor',C.panel,'BorderColor',C.border, ...
            'Title',ttl,'ForegroundColor','#FFFFFF', ...
            'FontSize',12,'FontWeight','bold');
    end

    function darkTheme(parent)
        % restyle web widgets (listbox/editfield/dropdown/spinner/
        % state buttons) to match the dark theme of the original app
        kids = parent.Children;
        for i = 1:numel(kids)
            k = kids(i);
            if isa(k,'matlab.ui.control.StateButton')
                try
                    k.BackgroundColor = '#1A1F2B';
                    if isprop(k,'FontColor') && ...
                            strcmp(k.FontColor,'#000000')
                        k.FontColor = '#E6EAF2';
                    end
                catch
                end
            elseif (isa(k,'matlab.ui.control.ListBox')      || ...
                isa(k,'matlab.ui.control.EditField')    || ...
                isa(k,'matlab.ui.control.DropDown')     || ...
                isa(k,'matlab.ui.control.Spinner')      || ...
                isa(k,'matlab.ui.control.TextArea'))
                try
                    k.BackgroundColor = '#1A1F2B';
                    k.FontColor       = '#E6EAF2';
                catch
                end
            elseif isa(k,'matlab.ui.container.Panel')        || ...
                   isa(k,'matlab.ui.container.ButtonGroup')
                darkTheme(k);
            end
        end
    end

    function l = mkLbl(parent,pos,txt,col,fs,fw)
        if nargin < 4, col = C.text; end
        if nargin < 5, fs  = 11;        end
        if nargin < 6, fw  = 'normal';  end
        l = uilabel(parent,'Text',txt,'Position',pos, ...
            'FontColor',col,'FontSize',fs,'FontWeight',fw, ...
            'BackgroundColor',C.panel);
    end

    function pageTitle(k,txt)
        uilabel(app.pages{k},'Text',txt,'Position',[15 755 600 30], ...
            'FontColor',C.title,'FontSize',17,'FontWeight','bold', ...
            'BackgroundColor',C.bg);
    end

    % ==================================================================
    %  PAGE A : Posture & Rhythm
    % ==================================================================
    function buildPageA()
        pageTitle(1,'A  Posture & Rhythm Management');

        % --- Desk Height Control ---
        p = mkPanel(1,[15 570 505 165],'Desk Height Control');
        app.aHeightVal = mkLbl(p,[380 95 110 35],'75 cm',C.cyan,22,'bold');
        app.aHeightSld = uislider(p,'Position',[30 85 330 3], ...
            'Limits',[60 120],'Value',75);
        app.aHeightSld.ValueChangingFcn = @(s,e)setHeightText(round(e.Value));
        mkLbl(p,[30 115 100 18],'Height',C.dim,10);
        app.aSitBtn  = uibutton(p,'push','Text','Sitting', ...
            'Position',[30 25 150 36],'BackgroundColor','#2A5C82', ...
            'FontColor',C.text,'FontWeight','bold');
        app.aStandBtn = uibutton(p,'push','Text','Standing', ...
            'Position',[200 25 150 36],'BackgroundColor',C.navOff, ...
            'FontColor',C.text,'FontWeight','bold');
        app.aSitBtn.ButtonPushedFcn   = @(s,e)setHeight(72);
        app.aStandBtn.ButtonPushedFcn = @(s,e)setHeight(108);

        % --- Sedentary Detection & Rhythm Alerts ---
        p = mkPanel(1,[15 340 505 210],'Sedentary Detection & Rhythm Alerts');
        mkLbl(p,[25 150 260 20],'Sitting time:',C.dim);
        app.aSitTime = mkLbl(p,[240 150 120 20],'0 min',C.orange,12,'bold');
        mkLbl(p,[25 120 260 20],'Since last drink:',C.dim);
        app.aDrinkTime = mkLbl(p,[240 120 120 20],'10 min',C.cyan,12,'bold');
        mkLbl(p,[25 90 260 20],'Since last stretch:',C.dim);
        app.aStretchTime = mkLbl(p,[240 90 120 20],'5 min',C.green,12,'bold');
        mkLbl(p,[25 50 280 20],'Sedentary alert interval (min):',C.text);
        app.aSedSpin = uispinner(p,'Position',[310 48 80 26], ...
            'Limits',[5 240],'Value',45,'RoundFractionalValue','on');
        mkLbl(p,[25 15 280 20],'Water reminder interval (min):',C.text);
        app.aWaterSpin = uispinner(p,'Position',[310 13 80 26], ...
            'Limits',[5 240],'Value',30,'RoundFractionalValue','on');

        % --- AI Posture Recognition ---
        p = mkPanel(1,[540 470 490 395],'AI Posture Recognition');
        app.aPostureList = uilistbox(p,'Position',[15 15 460 335], ...
            'Items',{'Upright (Good)  ✓';'Forward Lean  (!)'; ...
                     'Head Protrusion (!)';'Spinal Tilt  (X)'; ...
                     'Standing (Good)  ✓'},'Value','Upright (Good)  ✓');

        % --- Work Duration Monitor ---
        p = mkPanel(1,[540 300 490 150],'Work Duration Monitor');
        app.aWorkTime = mkLbl(p,[330 85 150 35],'0 h 0 min',C.cyan,20,'bold');
        mkLbl(p,[15 90 180 20],'Today''s time:',C.dim);
        mkLbl(p,[15 45 460 20],'Focus blocks: 0    Avg: 0 min/block',C.text);
        mkLbl(p,[15 15 150 20],'Active score:',C.dim);
        mkLbl(p,[140 15 150 20],'82 / 100',C.green,12,'bold');

        % --- Personalized Height Learning ---
        p = mkPanel(1,[15 30 505 290],'Personalized Height Learning');
        mkLbl(p,[15 235 300 20],'Learned height preferences:',C.dim);
        app.aLearnList = uilistbox(p,'Position',[15 75 475 150], ...
            'Items',{'Sitting preference: 72 cm'; ...
                     'Standing preference: 108 cm'; ...
                     'Reading preference: 70 cm'}, ...
            'Value','Sitting preference: 72 cm');
        app.aLearnBtn = uibutton(p,'push','Text','Learn New Preference', ...
            'Position',[15 20 220 40],'BackgroundColor','#2E7D32', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.aLearnBtn.ButtonPushedFcn = @(s,e)learnNewPref();
    end

    function setHeightText(v)
        app.aHeightVal.Text = sprintf('%d cm',v);
    end
    function setHeight(v)
        app.aHeightSld.Value = v;
        setHeightText(v);
    end
    function learnNewPref()
        cur = app.aHeightSld.Value;
        newv = sprintf('%s preference: %d cm','Learned',round(cur));
        app.aLearnList.Items{end+1} = newv; %#ok<AGROW>
        app.aLearnList.Value = newv;
    end

    % ==================================================================
    %  PAGE B : Adaptive Lighting
    % ==================================================================
    function buildPageB()
        pageTitle(2,'B  Adaptive Lighting & Visual Comfort');

        % --- Brightness & Color Temperature ---
        p = mkPanel(2,[15 570 505 165],'Brightness & Color Temperature');
        mkLbl(p,[15 100 120 20],'Brightness',C.text);
        app.bBrightSld = uislider(p,'Position',[140 100 250 3], ...
            'Limits',[0 100],'Value',70);
        app.bBrightVal = mkLbl(p,[420 95 80 25],'70%',C.yellow,16,'bold');
        app.bBrightSld.ValueChangingFcn = ...
            @(s,e)sr(e.Value,'bBrightVal','%d%%');
        mkLbl(p,[15 50 120 20],'Color Temp',C.text);
        app.bTempSld = uislider(p,'Position',[140 50 250 3], ...
            'Limits',[2700 6500],'Value',5000);
        app.bTempVal = mkLbl(p,[420 45 80 25],'5000 K',C.purple,16,'bold');
        app.bTempSld.ValueChangingFcn = ...
            @(s,e)sr(round(e.Value),'bTempVal','%d K');

        % --- Ambient Light Sensing ---
        p = mkPanel(2,[540 570 490 165],'Ambient Light Sensing');
        mkLbl(p,[15 100 250 20],'Current ambient intensity:',C.dim);
        app.bLuxVal = mkLbl(p,[15 45 250 45],'342 lux',C.yellow,28,'bold');
        app.bAutoChk = uibutton(p,'state','Text','Auto-dim:  Enabled', ...
            'Position',[290 55 190 26],'Value',true,'FontColor',C.text);
        app.bAutoChk.ValueChangedFcn = @(s,e)toggleText( ...
            s,'Auto-dim:  Enabled','Auto-dim:  Disabled');

        % --- Lighting Modes ---
        p = mkPanel(2,[15 30 505 520],'Lighting Modes');
        app.bModeList = uilistbox(p,'Position',[15 15 475 480], ...
            'Items',{'Reading';'Meeting / Conference';'Night Soft Light'; ...
                     'Eye Protection';'Anti-Glare';'High CRI'; ...
                     'Desk Spotlight'},'Value','Reading');

        % --- Light Preview ---
        p = mkPanel(2,[540 30 490 520],'Light Preview');
        app.bPrevAx = uiaxes(p,'Position',[15 15 460 480], ...
            'BackgroundColor','#0A0D14','Color','#0A0D14');
        app.bPrevAx.XColor = C.border; app.bPrevAx.YColor = C.border;
        title(app.bPrevAx,'preview','Color',C.dim);
        app.bModeList.ValueChangedFcn = @(s,e)drawPreview(s.Value);
        drawPreview('Reading');
    end

    function drawPreview(mode)
        x = linspace(0,1,50);
        switch mode
            case 'Night Soft Light', y = 0.25*ones(size(x));
            case 'Eye Protection',  y = 0.45*ones(size(x));
            otherwise,               y = 0.70*ones(size(x));
        end
        plot(app.bPrevAx,x,y*app.bBrightSld.Value/100,'-','LineWidth',3);
        ylim(app.bPrevAx,[0 1]); title(app.bPrevAx,mode,'Color',C.dim);
    end

    % ==================================================================
    %  PAGE C : Safety & Controls
    % ==================================================================
    function buildPageC()
        pageTitle(3,'C  Safety & Operational Simplicity');

        % --- Safety Protection Status ---
        p = mkPanel(3,[15 570 1015 165],'Safety Protection Status');
        app.cStatLbls = cell(4,1);
        items = {'Anti-pinch Detection','Anti-collision Lift', ...
                 'Desk Stability Monitor','Obstacle Scan'};
        vals  = {'OK',C.green;'OK',C.green;'OK',C.green; ...
                 'Calibrate',C.red};
        for k = 1:4
            mkLbl(p,[15+(k-1)*250 95 230 22],items{k},C.text,12);
            app.cStatLbls{k} = mkLbl(p,[15+(k-1)*250 60 230 26], ...
                vals{k,1},vals{k,2},16,'bold');
        end

        % --- One-Touch Quick Actions ---
        p = mkPanel(3,[15 340 505 210],'One-Touch Quick Actions');
        spec = {'UP  Raise','#2A5C82';'DOWN  Lower','#2A5C82'; ...
                'Sitting','#2E7D32';'Standing','#2E7D32'; ...
                'Reset','#8D6E63';'Pause Lift','#B71C1C'};
        app.cActBtns = gobjects(6,1);
        for k = 1:6
            col = mod(k-1,3); row = floor((k-1)/3);
            app.cActBtns(k) = uibutton(p,'push','Text',spec{k,1}, ...
                'Position',[15+col*160 130-row*70 145 55], ...
                'BackgroundColor',spec{k,2},'FontColor','#FFFFFF', ...
                'FontWeight','bold');
            app.cActBtns(k).ButtonPushedFcn = ...
                @(s,e)logAction(s.Text);
        end

        % --- Operation Log ---
        p = mkPanel(3,[540 30 490 520],'Operation Log');
        app.cLogList = uilistbox(p,'Position',[15 15 460 480], ...
            'Items',{'[09:12] Desk raised to 108 cm (Standing mode)'; ...
                     '[09:55] Desk lowered to 72 cm (Sitting mode)'; ...
                     '[10:30] Sedentary alert sent'; ...
                     '[11:00] Anti-collision triggered — lift stopped'; ...
                     '[11:01] Obstacle cleared — lift resumed'; ...
                     '[12:15] Break mode activated'});

        % --- placeholder info panel ---
        p = mkPanel(3,[15 30 505 290],'Desk Motor Status');
        app.cMotorLbl = mkLbl(p,[15 200 460 30],'Motor: Idle',C.cyan,16,'bold');
        mkLbl(p,[15 150 460 22],'Load: 0 kg',C.dim);
        mkLbl(p,[15 110 460 22],'Temperature: 32 °C',C.dim);
        mkLbl(p,[15 70 460 22],'Firmware: v2.3.1',C.dim);
    end

    function logAction(txt)
        t = datetime('now','Format','HH:mm');
        entry = sprintf('[%s] %s',char(t),txt);
        app.cLogList.Items{end+1} = entry; %#ok<AGROW>
        app.cLogList.Value = entry;
        app.cMotorLbl.Text = sprintf('Motor: %s',txt);
    end

    % ==================================================================
    %  PAGE D : Environment
    % ==================================================================
    function buildPageD()
        pageTitle(4,'D  Environmental & Emotional Regulation');

        % --- Scent Diffusion ---
        p = mkPanel(4,[15 570 505 165],'Scent Diffusion');
        mkLbl(p,[15 100 140 20],'Scent Intensity',C.text);
        app.dScentSld = uislider(p,'Position',[160 100 230 3], ...
            'Limits',[0 100],'Value',30);
        app.dScentVal = mkLbl(p,[420 95 70 25],'30%',C.purple,16,'bold');
        app.dScentSld.ValueChangingFcn = ...
            @(s,e)sr(round(e.Value),'dScentVal','%d%%');
        mkLbl(p,[15 55 110 20],'Scent Scene:',C.text);
        app.dScentDrop = uidropdown(p,'Position',[130 52 170 28], ...
            'Items',{'Fresh Lemon','Lavender','Mint','Citrus','Wood Scent', ...
                     'No Scent'});
        mkLbl(p,[15 15 460 22],'Diffuser status: ',C.dim);
        app.dScentStat = mkLbl(p,[135 15 300 22],'Running OK',C.green, ...
            11,'bold');

        % --- Micro Airflow ---
        p = mkPanel(4,[540 570 490 165],'Micro Airflow Circulation');
        mkLbl(p,[15 100 120 20],'Fan Speed',C.text);
        app.dFanSld = uislider(p,'Position',[140 100 230 3], ...
            'Limits',[0 100],'Value',20);
        app.dFanVal = mkLbl(p,[400 95 70 25],'20%',C.green,16,'bold');
        app.dFanSld.ValueChangingFcn = @(s,e)sr(round(e.Value),'dFanVal','%d%%');
        mkLbl(p,[15 55 460 22],'Low-noise operation (< 25 dB)',C.green);
        mkLbl(p,[15 15 460 22],'Current noise: ',C.dim);
        mkLbl(p,[130 15 200 22],'22 dB  OK',C.green,11,'bold');

        % --- Humidity ---
        p = mkPanel(4,[15 340 505 210],'Local Humidity Control');
        mkLbl(p,[15 150 140 20],'Target Humidity',C.text);
        app.dHumSld = uislider(p,'Position',[160 150 250 3], ...
            'Limits',[30 80],'Value',55);
        app.dHumVal = mkLbl(p,[420 145 70 25],'55%',C.cyan,16,'bold');
        app.dHumSld.ValueChangingFcn = @(s,e)sr(round(e.Value),'dHumVal','%d%%');
        mkLbl(p,[15 95 180 20],'Nano-mist Intensity',C.text);
        uislider(p,'Position',[200 95 210 3],'Limits',[0 100],'Value',40);
        mkLbl(p,[15 40 220 22],'Measured humidity:',C.dim);
        mkLbl(p,[170 40 150 22],'52%',C.cyan,12,'bold');

        % --- Mood Atmosphere Light ---
        p = mkPanel(4,[540 340 490 210],'Mood Atmosphere Light');
        mspec = {'Focus','#1E5FBF';'Relax','#1E7F5F';'Recover','#B8860B'; ...
                 'Creative','#7E3A9E';'Energy','#B71C1C'};
        app.dMoodBtns = gobjects(5,1);
        for k = 1:5
            app.dMoodBtns(k) = uibutton(p,'push','Text',mspec{k,1}, ...
                'Position',[15+(k-1)*93 140 82 40], ...
                'BackgroundColor',mspec{k,2},'FontColor','#FFFFFF', ...
                'FontWeight','bold','FontSize',10);
            app.dMoodBtns(k).ButtonPushedFcn = ...
                @(s,e)setMood(s.Text);
        end
        mkLbl(p,[15 95 460 22],'Current mode: ',C.dim);
        app.dMoodLbl = mkLbl(p,[120 95 200 22],'Focus',C.cyan,12,'bold');
        mkLbl(p,[15 45 200 22],'Ambient brightness:',C.text);
        uislider(p,'Position',[200 45 250 3],'Limits',[0 100],'Value',60);

        % --- Combined Environment Scenes ---
        p = mkPanel(4,[15 30 1015 290],'Combined Environment Scenes');
        sspec = {'Night Recovery','Low noise, dim, lavender, high humidity', ...
                 '#3A3A6F'; ...
                 'Deep Focus','Mint, mid-bright, daylight, airflow','#1E5FBF'; ...
                 'Midday Break','Warm light, scent, low humidity','#B8860B'; ...
                 'Creative Boost','Color light, citrus, moderate humidity', ...
                 '#7E3A9E'};
        app.dSceneBtns = gobjects(4,1);
        for k = 1:4
            col = mod(k-1,2); row = floor((k-1)/2);
            app.dSceneBtns(k) = uibutton(p,'push','Text', ...
                sprintf('%s\n%s',sspec{k,1},sspec{k,2}), ...
                'Position',[20+col*500 145-row*130 470 115], ...
                'BackgroundColor',sspec{k,3},'FontColor','#FFFFFF', ...
                'FontWeight','bold','FontSize',11);
        end
    end

    function setMood(m)
        app.dMoodLbl.Text = m;
    end

    % ==================================================================
    %  PAGE E : Space & Objects
    % ==================================================================
    function buildPageE()
        pageTitle(5,'E  Spatial Organisation & Object Memory');

        app.eItems = {'Phone  ->  Right Drawer A'; ...
                      'Charging Cable  ->  Left Drawer B'; ...
                      'Keys  ->  Hook Area'; ...
                      'Notebook  ->  Shelf'};

        % --- Item Location Query ---
        p = mkPanel(5,[15 470 505 265],'Item Location Query');
        mkLbl(p,[15 195 110 22],'Search item:',C.text);
        app.eSearchEdt = uieditfield(p,'text','Position',[130 192 240 28], ...
            'Value','');
        app.eSearchBtn = uibutton(p,'push','Text','Search', ...
            'Position',[385 190 100 32],'BackgroundColor','#2A5C82', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.eSearchBtn.ButtonPushedFcn = @(s,e)doSearch();
        app.eStatusLbl = uilabel(p,'Text','Awaiting query...', ...
            'Position',[15 160 460 22],'FontColor',C.dim, ...
            'BackgroundColor',C.panel);
        mkLbl(p,[15 135 200 20],'Registered items:',C.dim);
        app.eItemList = uilistbox(p,'Position',[15 60 475 70], ...
            'Items',app.eItems,'Value',app.eItems{1});
        app.eRegBtn = uibutton(p,'push','Text','+ Register New Item (RFID)', ...
            'Position',[15 12 260 40],'BackgroundColor','#2E7D32', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.eRegBtn.ButtonPushedFcn = @(s,e)registerItem();

        % --- RFID Recognition Status ---
        p = mkPanel(5,[540 470 490 265],'RFID Recognition Status');
        app.eRfidList = uilistbox(p,'Position',[15 15 460 215], ...
            'Items',{'[RFID-001] Phone  ->  Located (Right Drawer A)'; ...
                     '[RFID-002] Cable  ->  Located (Left Drawer B)'; ...
                     '[RFID-003] Keys  ->  Located (Hook Area)'; ...
                     '[RFID-004] Passport  ->  Not detected (!)'; ...
                     '[RFID-005] Remote  ->  Unknown location (?)'}, ...
            'Value','[RFID-001] Phone  ->  Located (Right Drawer A)');

        % --- Desk Grid Layout ---
        p = mkPanel(5,[15 30 505 420],'Desk Grid Layout (Modular)');
        app.eGridAx = uiaxes(p,'Position',[15 15 475 380], ...
            'BackgroundColor','#0A0D14','Color','#0A0D14');
        app.eGridAx.XColor = C.border; app.eGridAx.YColor = C.border;
        drawGrid();

        % --- AI Organisation Suggestions ---
        p = mkPanel(5,[540 30 490 420],'AI Organisation Suggestions');
        app.eSuggList = uilistbox(p,'Position',[15 15 460 375], ...
            'Items',{'Right side cluttered — move to Drawer A'; ...
                     'Notebook can go to shelf to free desk space'; ...
                     'Cable tangled — suggest cable clip'; ...
                     'Main work zone optimised: 95% utilisation'; ...
                     '3 items unused for 7+ days detected'}, ...
            'Value','Right side cluttered — move to Drawer A');
    end

    function drawGrid()
        ax = app.eGridAx; hold(ax,'on');
        for x = 0.1:0.2:0.9
            plot(ax,[x x],[0 1],'-','Color','#262C3A');
        end
        for y = 0.1:0.2:0.9
            plot(ax,[0 1],[y y],'-','Color','#262C3A');
        end
        rectangle(ax,'Position',[0.5 0.6 0.25 0.15], ...
            'FaceColor','#2A5C82','EdgeColor','none');
        title(ax,'desk grid','Color',C.dim);
        axis(ax,'off');
    end

    function doSearch()
        q = lower(strtrim(app.eSearchEdt.Value));
        hit = '';
        for k = 1:numel(app.eItems)
            if contains(lower(app.eItems{k}),q) && ~isempty(q)
                hit = app.eItems{k}; break;
            end
        end
        if ~isempty(hit)
            app.eItemList.Value = hit;
            app.eStatusLbl.Text = ['Found:  ' hit];
            app.eStatusLbl.FontColor = C.green;
        else
            app.eStatusLbl.Text = 'No matching item found';
            app.eStatusLbl.FontColor = C.red;
        end
    end

    function registerItem()
        n = numel(app.eItems) + 1;
        entry = sprintf('New Item %d  ->  Desk Zone %d',n,mod(n,4)+1);
        app.eItems{end+1} = entry; %#ok<AGROW>
        app.eItemList.Items = app.eItems;
        app.eItemList.Value = entry;
        tag = sprintf('[RFID-%03d] New Item %d  ->  Registered',n,n);
        app.eRfidList.Items{end+1} = tag; %#ok<AGROW>
        app.eRfidList.Value = tag;
    end

    % ==================================================================
    %  PAGE F : Privacy
    % ==================================================================
    function buildPageF()
        pageTitle(6,'F  Privacy & Personalised Control');

        % --- Data Storage Strategy ---
        p = mkPanel(6,[15 570 505 165],'Data Storage Strategy');
        mkLbl(p,[15 115 140 20],'Storage mode:',C.text);
        app.fStoreGrp = uibuttongroup(p,'Position',[160 100 300 40], ...
            'BackgroundColor',C.panel,'BorderType','none');
        rb1 = uiradiobutton(app.fStoreGrp,'Text','Local-first', ...
            'Position',[10 5 130 22],'FontColor',C.text);
        uiradiobutton(app.fStoreGrp,'Text','Cloud Backup', ...
            'Position',[150 5 140 22],'FontColor',C.text);
        app.fStoreGrp.SelectedObject = rb1;
        mkLbl(p,[15 75 140 20],'Matter Protocol:',C.text);
        mkLbl(p,[160 75 320 20],'Enabled (Local LAN)',C.green,11,'bold');
        mkLbl(p,[15 45 140 20],'Encryption:',C.text);
        mkLbl(p,[160 45 320 20],'AES-256 end-to-end',C.yellow,11,'bold');
        mkLbl(p,[15 15 140 20],'Data retention:',C.text);
        mkLbl(p,[160 15 320 20],'90-day auto-purge',C.text);

        % --- Sensor On/Off ---
        p = mkPanel(6,[540 570 490 165],'Sensor On/Off Controls');
        sensors = {'Camera (Posture AI)','Ambient Light Sensor', ...
                   'RFID Reader','Microphone (Voice)', ...
                   'Temp/Humidity Sensor','Distance Sensor'};
        sensOn  = [true true true false true true];
        app.fSensorChks = gobjects(6,1);
        for k = 1:6
            col = floor((k-1)/3); row = mod(k-1,3);
            app.fSensorChks(k) = uibutton(p,'state','Text',sensors{k}, ...
                'Position',[15+col*240 100-row*35 235 26], ...
                'Value',sensOn(k),'FontColor',C.text);
        end

        % --- AI Automation Permissions ---
        p = mkPanel(6,[15 260 505 290],'AI Automation Permissions');
        perms = {'AI auto-adjust desk height';'AI auto-adjust lighting'; ...
                 'AI learn user habits';'AI send health reminders'; ...
                 'AI optimise scene switching'};
        permOn = [true true true true false];
        app.fPermChks = gobjects(5,1);
        for k = 1:5
            app.fPermChks(k) = uibutton(p,'state','Text',perms{k}, ...
                'Position',[15 220-(k-1)*38 400 26],'Value',permOn(k), ...
                'FontColor',C.cyan);
        end
        app.fClearBtn = uibutton(p,'push','Text','Clear Local Data', ...
            'Position',[15 15 220 40],'BackgroundColor','#B71C1C', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.fClearBtn.ButtonPushedFcn = @(s,e)uialert(app.fig, ...
            'This will erase all locally stored data. (demo)','Confirm', ...
            'Icon','warning');

        % --- User Profile ---
        p = mkPanel(6,[540 260 490 290],'User Profile');
        mkLbl(p,[15 225 180 22],'Current user:',C.dim);
        mkLbl(p,[120 225 200 22],'User A',C.cyan,12,'bold');
        app.fUserDrop = uidropdown(p,'Position',[15 185 200 28], ...
            'Items',{'User A','User B','Guest'});
        app.fPrefList = uilistbox(p,'Position',[15 15 460 160], ...
            'Items',{'Preferred sitting height: 72 cm'; ...
                     'Preferred standing height: 108 cm'; ...
                     'Preferred color temp: 5000 K'; ...
                     'Preferred brightness: 75%'});

        % --- AI Decision Explanations ---
        p = mkPanel(6,[15 30 505 210],'AI Decision Explanations');
        app.fDecList = uilistbox(p,'Position',[15 15 475 155], ...
            'Items',{'Desk raised  ->  You have been standing for 2 min'; ...
                     'Color temp lowered  ->  Time 19:30, reducing blue light'; ...
                     'Lavender activated  ->  Elevated HR detected, relaxation suggested'; ...
                     'Stretch reminder  ->  45-min sedentary threshold reached'; ...
                     'Water reminder  ->  Last drink was 32 min ago'});

        % --- Personalised Privacy Policy ---
        p = mkPanel(6,[540 30 490 210],'Personalised Privacy Policy');
        mkLbl(p,[15 150 460 20],'AI Sensing Accuracy',C.text,12,'bold');
        mkLbl(p,[15 115 160 20],'Data reporting rate:',C.text);
        app.fRateSld = uislider(p,'Position',[180 115 200 3], ...
            'Limits',[0 100],'Value',85);
        mkLbl(p,[15 90 80 18],'Low',C.dim,9);
        mkLbl(p,[300 90 80 18],'High',C.dim,9);
        mkLbl(p,[15 45 160 20],'Explainability hints:',C.text);
        app.fExpChk = uibutton(p,'state','Text','Show AI decision reasons', ...
            'Position',[180 45 290 26],'Value',true,'FontColor',C.green);
    end

    % ==================================================================
    %  PAGE G : Scene Switcher
    % ==================================================================
    function buildPageG()
        pageTitle(7,'G  Multi-Scenario Switching');

        mkLbl(app.pages{7},[15 715 120 24],'Active Scene:',C.dim,13);
        app.gActiveLbl = mkLbl(app.pages{7},[130 713 350 26], ...
            '>> Focus Mode',C.cyan,16,'bold');

        cards = {'Focus Mode','72cm / 5000K / 80% / Mint / Low noise','#1E5FBF'; ...
                 'Reading Mode','70cm / 4200K / 75% / Eye-care / Anti-glare','#1E7F5F'; ...
                 'Drawing Mode','0->15deg tilt / 6000K / High CRI','#7E3A9E'; ...
                 'Writing Mode','72cm / 4500K / 70% / Wood scent','#2A6F82'; ...
                 'Meeting Mode','108cm / 5500K / 100% / No scent','#9E5A1E'; ...
                 'Live Stream Mode','108cm / 5500K / 100% / Citrus','#9E1E1E'; ...
                 'Standing Mode','108cm / 5000K / 75% / Airflow','#3A6F2A'; ...
                 'Break Mode','60cm / 2800K / 15% / Lavender','#3A3A6F'};
        app.gCardBtns = gobjects(8,1);
        for k = 1:8
            col = mod(k-1,4); row = floor((k-1)/4);
            app.gCardBtns(k) = uibutton(app.pages{7},'push','Text', ...
                sprintf('%s\n%s',cards{k,1},cards{k,2}), ...
                'Position',[15+col*253 545-row*150 240 135], ...
                'BackgroundColor',cards{k,3},'FontColor','#FFFFFF', ...
                'FontWeight','bold','FontSize',11);
            app.gCardBtns(k).ButtonPushedFcn = ...
                @(s,e)activateScene(s.Text);
        end

        % --- Desk Tilt Angle Control ---
        p = mkPanel(7,[15 30 505 340],'Desk Tilt Angle Control');
        mkLbl(p,[15 265 120 22],'Tilt Angle',C.text);
        app.gTiltVal = mkLbl(p,[400 260 90 28],'0 deg',C.orange,18,'bold');
        app.gTiltSld = uislider(p,'Position',[30 230 380 3], ...
            'Limits',[0 30],'Value',0);
        app.gTiltSld.ValueChangingFcn = ...
            @(s,e)srTilt(round(e.Value));
        app.gTiltList = uilistbox(p,'Position',[15 90 475 110], ...
            'Items',{'0 deg  Typing / Standing'; ...
                     '15 deg  Drawing / Sketching'; ...
                     '30 deg  Reading / Presenting'});
        mkLbl(p,[15 20 460 40],'Preset angles adapt desk slope to task.', ...
            C.dim,10);

        % --- Embedded Control Screen ---
        p = mkPanel(7,[540 30 490 340],'Embedded Control Screen');
        mkLbl(p,[15 265 180 22],'Screen brightness:',C.text);
        uislider(p,'Position',[200 265 250 3],'Limits',[0 100],'Value',75);
        mkLbl(p,[15 190 130 22],'UI density:',C.text);
        app.gDensGrp = uibuttongroup(p,'Position',[140 175 320 40], ...
            'BackgroundColor',C.panel,'BorderType','none');
        r1 = uiradiobutton(app.gDensGrp,'Text','Minimal', ...
            'Position',[10 5 100 22],'FontColor',C.text);
        r2 = uiradiobutton(app.gDensGrp,'Text','Standard', ...
            'Position',[115 5 100 22],'FontColor',C.text);
        uiradiobutton(app.gDensGrp,'Text','Detailed', ...
            'Position',[220 5 100 22],'FontColor',C.text);
        app.gDensGrp.SelectedObject = r2;
        mkLbl(p,[15 100 140 22],'Contextual UI:',C.text);
        uibutton(p,'state','Text','Auto-update UI on scene switch', ...
            'Position',[150 100 320 26],'Value',true,'FontColor',C.green);
        mkLbl(p,[15 20 460 40], ...
            'Embedded screen shows task-relevant controls only.', ...
            C.dim,10);
    end

    function activateScene(txt)
        parts = strsplit(txt,newline);
        app.gActiveLbl.Text = ['>> ' parts{1}];
    end

    function srTilt(v)
        app.gTiltVal.Text = sprintf('%d deg',v);
    end

    % ==================================================================
    %  PAGE H : Voice Interaction & Control
    % ==================================================================
    function buildPageH()
        pageTitle(8,'H  Voice Interaction & Control');

        app.hPhrases = {'sit down';'stand up';'raise';'lower'; ...
            'set height seventy';'set height seventy five'; ...
            'set height eighty';'set height ninety'; ...
            'set height one hundred';'set height one hundred ten'; ...
            'brightness up';'brightness down'; ...
            'set brightness fifty';'set brightness seventy'; ...
            'set brightness one hundred'; ...
            'warmer light';'cooler light'; ...
            'reading light';'meeting light';'night light'; ...
            'eye protection light'; ...
            'anti glare light';'high c r i light';'spotlight'; ...
            'auto dim on';'auto dim off'; ...
            'fan up';'fan down'; ...
            'humidity fifty';'humidity sixty'; ...
            'scent on';'scent off'; ...
            'lavender scent';'mint scent';'lemon scent';'citrus scent'; ...
            'mood focus';'mood relax';'mood recover'; ...
            'mood creative';'mood energy'; ...
            'night recovery scene';'deep focus scene'; ...
            'midday break scene';'creative boost scene'; ...
            'check safety';'anti pinch';'collision check'; ...
            'obstacle scan';'reset desk';'pause lift'; ...
            'tilt zero';'tilt fifteen';'tilt thirty'; ...
            'find phone';'find keys';'find cable'; ...
            'register item';'tidy suggestions'; ...
            'privacy report';'stop automation'; ...
            'focus mode';'reading mode';'drawing mode'; ...
            'writing mode';'meeting mode';'live stream mode'; ...
            'standing mode';'break mode'; ...
            'status';'help';'stop listening'};

        % --- Voice Assistant ---
        p = mkPanel(8,[15 570 505 165],'Voice Assistant');
        mkLbl(p,[15 95 130 20],'Assistant state:',C.dim);
        app.hStateLbl = mkLbl(p,[15 50 200 40],'Idle',C.dim,20,'bold');
        app.hStartBtn = uibutton(p,'push','Text','Start Listening', ...
            'Position',[255 95 225 45],'BackgroundColor','#2E7D32', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.hStartBtn.ButtonPushedFcn = @(s,e)startVoice();
        app.hStopBtn = uibutton(p,'push','Text','Stop Listening', ...
            'Position',[255 35 225 45],'BackgroundColor','#B71C1C', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.hStopBtn.ButtonPushedFcn = @(s,e)stopVoice();
        mkLbl(p,[15 8 130 20],'Wake word:',C.text);
        uidropdown(p,'Position',[150 5 190 26], ...
            'Items',{'Hey SmartDesk','SmartDesk','None (always on)'});

        % --- Text-to-Speech Feedback ---
        p = mkPanel(8,[540 570 490 165],'Text-to-Speech Feedback');
        app.hTtsChk = uibutton(p,'state','Text','Speak actions aloud', ...
            'Position',[15 100 300 26],'Value',true,'FontColor',C.green);
        mkLbl(p,[15 60 60 20],'Rate:',C.text);
        app.hRateSld = uislider(p,'Position',[95 60 240 3], ...
            'Limits',[-3 3],'Value',0);
        app.hTestBtn = uibutton(p,'push','Text','Test Voice', ...
            'Position',[360 45 110 40],'BackgroundColor','#2A5C82', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.hTestBtn.ButtonPushedFcn = @(s,e)speak( ...
            'Smart Desk voice assistant is ready.');

        % --- Microphone Input Level ---
        p = mkPanel(8,[15 340 505 210],'Microphone Input Level');
        app.hMicAx = uiaxes(p,'Position',[15 55 475 110], ...
            'BackgroundColor','#0A0D14','Color','#0A0D14');
        app.hMicAx.XColor = C.border; app.hMicAx.YColor = C.border;
        axis(app.hMicAx,'off');
        drawMicBar(2);
        app.hLevelLbl = mkLbl(p,[15 15 250 22],'Level: 0 %',C.cyan,12,'bold');
        mkLbl(p,[270 15 220 22],'(updates while listening)',C.dim,9);

        % --- Command Tester ---
        p = mkPanel(8,[540 340 490 210],'Command Tester (simulate input)');
        mkLbl(p,[15 160 460 20],'Pick a phrase and send it as if spoken:', ...
            C.dim);
        app.hCmdDrop = uidropdown(p,'Position',[15 120 300 28], ...
            'Items',app.hPhrases);
        app.hSendBtn = uibutton(p,'push','Text','Send', ...
            'Position',[330 118 140 32],'BackgroundColor','#2A5C82', ...
            'FontColor','#FFFFFF','FontWeight','bold');
        app.hSendBtn.ButtonPushedFcn = ...
            @(s,e)onVoiceCmd(app.hCmdDrop.Value,0.99);
        mkLbl(p,[15 80 120 20],'Last heard:',C.dim);
        app.hLastLbl = mkLbl(p,[120 78 350 24],'" -- "',C.cyan,13,'bold');
        mkLbl(p,[15 15 460 40], ...
            'Recognised commands also fire from the real microphone.', ...
            C.dim,9);

        % --- Voice Command Log ---
        p = mkPanel(8,[15 30 1015 290],'Voice Command Log');
        app.hLogList = uilistbox(p,'Position',[15 10 985 235], ...
            'Items',{'[system] Voice module loaded. Say a command or use the tester.'});
    end

    function drawMicBar(lvl)
        ax = app.hMicAx; cla(ax);
        rectangle(ax,'Position',[0.02 0.15 0.96*max(lvl,1)/100 0.7], ...
            'FaceColor','#4FC3F7','EdgeColor','none');
        xlim(ax,[0 1]); ylim(ax,[0 1]);
    end

    function setState(txt,mode)
        app.hStateLbl.Text = txt;
        switch mode
            case 'on',   app.hStateLbl.FontColor = C.green;
            case 'warn', app.hStateLbl.FontColor = C.yellow;
            otherwise,   app.hStateLbl.FontColor = C.dim;
        end
    end

    function startVoice()
        if app.hListening, return; end
        try
            NET.addAssembly('System.Speech');
            if isempty(app.hRec)
                app.hRec = System.Speech.Recognition.SpeechRecognitionEngine();
                gb = System.Speech.Recognition.GrammarBuilder();
                gb.Append(System.Speech.Recognition.Choices(app.hPhrases));
                app.hRec.LoadGrammar(System.Speech.Recognition.Grammar(gb));
                app.hRec.SetInputToDefaultAudioDevice();
                try
                    addlistener(app.hRec,'SpeechRecognized', ...
                        @(s,e)onVoiceCmd(char(e.Result.Text), ...
                        double(e.Result.Confidence)));
                catch
                end
                try
                    addlistener(app.hRec,'AudioLevelUpdated', ...
                        @(s,e)onLevel(double(e.AudioLevel)));
                catch
                end
            end
            app.hRec.RecognizeAsync( ...
                System.Speech.Recognition.RecognizeMode.Multiple);
            app.hListening = true;
            setState('Listening...','on');
            voiceLog('[system] Listening started');
        catch ME
            app.hListening = true;
            app.hSimMode = true;
            setState('Simulated (no mic)','warn');
            voiceLog(['[system] Microphone unavailable: ' ME.message]);
            voiceLog('[system] Use the Command Tester instead');
        end
    end

    function stopVoice()
        if ~app.hListening, return; end
        app.hListening = false;
        try
            if ~isempty(app.hRec)
                app.hRec.RecognizeAsyncCancel();
            end
        catch
        end
        setState('Idle','off');
        drawMicBar(2);
        app.hLevelLbl.Text = 'Level: 0 %';
        voiceLog('[system] Listening stopped');
    end

    function onLevel(lvl)
        try
            lvl = max(min(round(lvl),100),0);
            app.hLevelLbl.Text = sprintf('Level: %d %%',lvl);
            drawMicBar(lvl);
        catch
        end
    end

    function onVoiceCmd(txt,conf)
        try
            app.hLastLbl.Text = ['"' txt '"'];
            voiceLog(sprintf('[%d%%] %s',round(conf*100),txt));
            ok = true;
            % ================== A : posture & height ==================
            switch txt
                case 'sit down'
                    switchPage(1); setHeight(72);
                    speak('Desk lowered to 72 centimeters');
                case 'stand up'
                    switchPage(1); setHeight(108);
                    speak('Desk raised to 108 centimeters');
                case 'raise'
                    switchPage(1); setHeight(app.aHeightSld.Value+5);
                    speak('Raising desk');
                case 'lower'
                    switchPage(1); setHeight(app.aHeightSld.Value-5);
                    speak('Lowering desk');
                case 'set height seventy'
                    switchPage(1); setHeight(70); speak('Height set to 70');
                case 'set height seventy five'
                    switchPage(1); setHeight(75); speak('Height set to 75');
                case 'set height eighty'
                    switchPage(1); setHeight(80); speak('Height set to 80');
                case 'set height ninety'
                    switchPage(1); setHeight(90); speak('Height set to 90');
                case 'set height one hundred'
                    switchPage(1); setHeight(100); speak('Height set to 100');
                case 'set height one hundred ten'
                    switchPage(1); setHeight(110); speak('Height set to 110');
                % ================== B : lighting ==========================
                case 'brightness up'
                    switchPage(2); setVal(app.bBrightSld, ...
                        app.bBrightSld.Value+10,'bBrightVal','%d%%');
                    speak('Brightness increased');
                case 'brightness down'
                    switchPage(2); setVal(app.bBrightSld, ...
                        app.bBrightSld.Value-10,'bBrightVal','%d%%');
                    speak('Brightness decreased');
                case 'set brightness fifty'
                    switchPage(2); setVal(app.bBrightSld,50, ...
                        'bBrightVal','%d%%'); speak('Brightness 50 percent');
                case 'set brightness seventy'
                    switchPage(2); setVal(app.bBrightSld,70, ...
                        'bBrightVal','%d%%'); speak('Brightness 70 percent');
                case 'set brightness one hundred'
                    switchPage(2); setVal(app.bBrightSld,100, ...
                        'bBrightVal','%d%%'); speak('Brightness 100 percent');
                case 'warmer light'
                    switchPage(2); setVal(app.bTempSld, ...
                        max(app.bTempSld.Value-300,2700),'bTempVal','%d K');
                    speak('Warmer light');
                case 'cooler light'
                    switchPage(2); setVal(app.bTempSld, ...
                        min(app.bTempSld.Value+300,6500),'bTempVal','%d K');
                    speak('Cooler light');
                case 'reading light'
                    switchPage(2); setLightMode('Reading');
                case 'meeting light'
                    switchPage(2); setLightMode('Meeting / Conference');
                case 'night light'
                    switchPage(2); setLightMode('Night Soft Light');
                case 'eye protection light'
                    switchPage(2); setLightMode('Eye Protection');
                case 'anti glare light'
                    switchPage(2); setLightMode('Anti-Glare');
                case 'high c r i light'
                    switchPage(2); setLightMode('High CRI');
                case 'spotlight'
                    switchPage(2); setLightMode('Desk Spotlight');
                case 'auto dim on'
                    switchPage(2); app.bAutoChk.Value = true;
                    app.bAutoChk.Text = 'Auto-dim:  Enabled';
                    speak('Auto dim enabled');
                case 'auto dim off'
                    switchPage(2); app.bAutoChk.Value = false;
                    app.bAutoChk.Text = 'Auto-dim:  Disabled';
                    speak('Auto dim disabled');
                % ================== C : safety & actions ==================
                case 'check safety'
                    switchPage(3);
                    speak('Safety status: three systems OK, obstacle scan needs calibration');
                case 'anti pinch'
                    switchPage(3); speak('Anti-pinch detection: OK');
                case 'collision check'
                    switchPage(3); speak('Anti-collision lift: OK');
                case 'obstacle scan'
                    switchPage(3);
                    voiceLog('[safety] Obstacle scan: calibrate recommended');
                    speak('Obstacle scan needs calibration');
                case 'reset desk'
                    switchPage(3); logAction('Reset');
                case 'pause lift'
                    switchPage(3); logAction('Pause Lift');
                % ================== D : environment =======================
                case 'fan up'
                    switchPage(4); setVal(app.dFanSld, ...
                        app.dFanSld.Value+10,'dFanVal','%d%%');
                    speak('Fan speed increased');
                case 'fan down'
                    switchPage(4); setVal(app.dFanSld, ...
                        max(app.dFanSld.Value-10,0),'dFanVal','%d%%');
                    speak('Fan speed decreased');
                case 'humidity fifty'
                    switchPage(4); setVal(app.dHumSld,50,'dHumVal','%d%%');
                    speak('Target humidity 50 percent');
                case 'humidity sixty'
                    switchPage(4); setVal(app.dHumSld,60,'dHumVal','%d%%');
                    speak('Target humidity 60 percent');
                case 'scent on'
                    switchPage(4); setVal(app.dScentSld,60,'dScentVal','%d%%');
                    app.dScentStat.Text = 'Running OK';
                    speak('Scent diffuser on');
                case 'scent off'
                    switchPage(4); setVal(app.dScentSld,0,'dScentVal','%d%%');
                    app.dScentStat.Text = 'Stopped';
                    speak('Scent diffuser off');
                case 'lavender scent'
                    switchPage(4); app.dScentDrop.Value = 'Lavender';
                    speak('Lavender scent selected');
                case 'mint scent'
                    switchPage(4); app.dScentDrop.Value = 'Mint';
                    speak('Mint scent selected');
                case 'lemon scent'
                    switchPage(4); app.dScentDrop.Value = 'Fresh Lemon';
                    speak('Lemon scent selected');
                case 'citrus scent'
                    switchPage(4); app.dScentDrop.Value = 'Citrus';
                    speak('Citrus scent selected');
                case 'mood focus'
                    switchPage(4); setMood('Focus'); speak('Focus mood');
                case 'mood relax'
                    switchPage(4); setMood('Relax'); speak('Relax mood');
                case 'mood recover'
                    switchPage(4); setMood('Recover'); speak('Recover mood');
                case 'mood creative'
                    switchPage(4); setMood('Creative'); speak('Creative mood');
                case 'mood energy'
                    switchPage(4); setMood('Energy'); speak('Energy mood');
                case 'night recovery scene'
                    switchPage(4); voiceLog('[scene] Night Recovery active');
                    speak('Night recovery scene activated');
                case 'deep focus scene'
                    switchPage(4); voiceLog('[scene] Deep Focus active');
                    speak('Deep focus scene activated');
                case 'midday break scene'
                    switchPage(4); voiceLog('[scene] Midday Break active');
                    speak('Midday break scene activated');
                case 'creative boost scene'
                    switchPage(4); voiceLog('[scene] Creative Boost active');
                    speak('Creative boost scene activated');
                % ================== E : space & objects ===================
                case 'find phone'
                    switchPage(3); switchPage(5); doFind('Phone');
                case 'find keys'
                    switchPage(5); doFind('Keys');
                case 'find cable'
                    switchPage(5); doFind('Cable');
                case 'register item'
                    switchPage(5); registerItem();
                case 'tidy suggestions'
                    switchPage(5);
                    speak('Top suggestion: move right side clutter to drawer A');
                % ================== F : privacy ===========================
                case 'privacy report'
                    switchPage(6);
                    speak('Data is local first, AES-256 encrypted. Microphone off.');
                case 'stop automation'
                    switchPage(6);
                    for k = 1:5, app.fPermChks(k).Value = false; end
                    speak('All AI automation disabled');
                % ================== G : scenes & tilt =====================
                case 'focus mode'
                    activateVoiceScene('Focus Mode','Focus mode activated');
                case 'reading mode'
                    activateVoiceScene('Reading Mode','Reading mode activated');
                case 'drawing mode'
                    activateVoiceScene('Drawing Mode','Drawing mode activated');
                case 'writing mode'
                    activateVoiceScene('Writing Mode','Writing mode activated');
                case 'meeting mode'
                    activateVoiceScene('Meeting Mode','Meeting mode activated');
                case 'live stream mode'
                    activateVoiceScene('Live Stream Mode', ...
                        'Live stream mode activated');
                case 'standing mode'
                    activateVoiceScene('Standing Mode','Standing mode activated');
                case 'break mode'
                    activateVoiceScene('Break Mode','Break mode activated');
                case 'tilt zero'
                    switchPage(7); app.gTiltSld.Value = 0; srTilt(0);
                    speak('Tilt set to zero degrees');
                case 'tilt fifteen'
                    switchPage(7); app.gTiltSld.Value = 15; srTilt(15);
                    speak('Tilt set to fifteen degrees');
                case 'tilt thirty'
                    switchPage(7); app.gTiltSld.Value = 30; srTilt(30);
                    speak('Tilt set to thirty degrees');
                % ================== system ================================
                case 'status'
                    speak(sprintf(['Current height %d centimeters, ' ...
                        'brightness %d percent, active scene %s'], ...
                        round(app.aHeightSld.Value), ...
                        round(app.bBrightSld.Value), ...
                        strrep(app.gActiveLbl.Text,'>> ','')));
                case 'help'
                    speak(['Say sit down, stand up, brightness up, ' ...
                        'reading light, fan up, find phone, focus mode, ' ...
                        'or status.']);
                case 'stop listening'
                    stopVoice();
                otherwise
                    ok = false;
                    speak('Command not recognized');
            end
            if ok
                voiceLog('[ok] executed');
            end
        catch
        end
    end

    function setVal(sld,v,field,fmt)
        sld.Value = v;
        app.(field).Text = sprintf(fmt,round(v));
    end

    function setLightMode(m)
        app.bModeList.Value = m;
        drawPreview(m);
        speak([m ' lighting mode']);
    end

    function activateVoiceScene(name,spoken)
        switchPage(7);
        idx = [find(strcmp(cardsSceneNames(),name))];
        if ~isempty(idx)
            app.gActiveLbl.Text = ['>> ' name];
            voiceLog(['[scene] ' name ' activated']);
            speak(spoken);
        end
    end

    function doFind(item)
        q = lower(item);
        hit = '';
        for k = 1:numel(app.eItems)
            if contains(lower(app.eItems{k}),q)
                hit = app.eItems{k}; break;
            end
        end
        if ~isempty(hit)
            app.eItemList.Value = hit;
            app.eStatusLbl.Text = ['Found:  ' hit];
            app.eStatusLbl.FontColor = C.green;
            speak([item ' is at ' strrep(hit,'  ->  ',' ')]);
        else
            app.eStatusLbl.Text = 'No matching item found';
            app.eStatusLbl.FontColor = C.red;
            speak(['Cannot find ' item]);
        end
    end

    function names = cardsSceneNames()
        names = {'Focus Mode','Reading Mode','Drawing Mode', ...
                 'Writing Mode','Meeting Mode','Live Stream Mode', ...
                 'Standing Mode','Break Mode'};
    end

    function speak(txt)
        try
            if ~app.hTtsChk.Value, return; end
            if isempty(app.hSynth)
                NET.addAssembly('System.Speech');
                app.hSynth = System.Speech.Synthesis.SpeechSynthesizer();
            end
            app.hSynth.Rate = round(app.hRateSld.Value);
            app.hSynth.SpeakAsync(txt);
        catch
        end
    end

    function voiceLog(txt)
        t = char(datetime('now','Format','HH:mm:ss'));
        app.hLogList.Items{end+1} = sprintf('[%s] %s',t,txt); %#ok<AGROW>
        app.hLogList.Value = app.hLogList.Items{end};
    end

    % ==================================================================
    %  shared helpers
    % ==================================================================
    function sr(v,field,fmt)
        app.(field).Text = sprintf(fmt,v);
    end

    function toggleText(src,onTxt,offTxt)
        if src.Value, src.Text = onTxt; else, src.Text = offTxt; end
    end

    function switchPage(k)
        for j = 1:8
            app.pages{j}.Visible = 'off';
            app.navBtn(j).BackgroundColor = C.navOff;
        end
        app.pages{k}.Visible = 'on';
        app.navBtn(k).BackgroundColor = C.navOn;
    end

    function startClock()
        app.timer = timer('ExecutionMode','fixedRate','Period',1, ...
            'TimerFcn',@(~,~)tick());
        start(app.timer);
        tick();
    end

    function tick()
        try
            app.clockLbl.Text = char(datetime('now','Format','HH:mm:ss'));
        catch
        end
        try
            if app.hListening && app.hSimMode
                onLevel(15 + round(55*rand));
            end
        catch
        end
    end

    function stopClock()
        try
            stopVoice();
        catch
        end
        try
            stop(app.timer); delete(app.timer);
        catch
        end
        delete(app.fig);
    end

end
