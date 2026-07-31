%% FIRST-LEVEL SUBJECTIVE RATING COEFFICIENT GLM: VISIT 1

%% Load in parameters and create a cell array per visit.
cohort = 1

if cohort == 1 % pre-ECT 
filepath = fullfile('Data/ECT/visit-1/matlab_regressors', 'RegressorsV1.mat');
load(filepath, 'RegressorsV1');

subjnum = [1:25];
subID = [1:25];

for o = 1:numel(subjnum) 
    numscans(1,o) = numel(dir(['/Volumes/Data/ECT/ECT_' num2str(subjnum(1,o)) '/visit-1/func/swvol*.nii'])) - 1; 
end 

elseif cohort == 2 % non-ECT 
filepath = fullfile('Data/non-ECT/visit-1/matlab_regressors', 'RegressorsV1.mat');
load(filepath, 'RegressorsV1');

subjnum = [1:38];
subID = [1:38];

for o = 1:numel(subjnum) 
    numscans(1,o) = numel(dir(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(subjnum(1,o)) '/visit-1/func/swvol*.nii'])) - 1; 
end 


elseif cohort == 3 % no-depression 
filepath = fullfile('Data/no-depression/visit-1/matlab_regressors', 'RegressorsV1.mat');
load(filepath, 'RegressorsV1');

subjnum = [1:41];
subID = [1:41];

for i = 1:numel(subjnum) 
    numscans(1,i) = numel(dir(['/Volumes/Data/No-depression/No-depression_' num2str(subjnum(1,i)) '/visit-1/func/swvol*.nii'])) - 1; 
end 
end

%% imaging data 
nrun = 1;
directory = {'v1_PosNegAffect_glm'}; 

for i = 1:size(subjnum,2)
    disp(['Participant ' num2str(i)])
    clear matlabbatch
    cond = 0;
%     num_subjs_ticker = 0
%% Specify the directory, scan timing details (TR, etc.), and scans to be included in each subject's GLM
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1; %interscan interval 
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 72; %microtime resolution 
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;  %microtime onset 
            
    if cohort == 1
        cd /Volumes/Data/ECT
        matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(['/Volumes/Data/ECT/ECT_' num2str(subjnum(1,i)) '/visit-1/spm/' char(directory)]); 
        for j = 0:numscans(1,i)
            if j <= 9
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/ECT/ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol000' num2str(j) '.nii,1']);
            elseif j > 9 && j <= 99
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/ECT/ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol00' num2str(j) '.nii,1']);
            elseif j > 99 && j <= 999
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/ECT/ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol0' num2str(j) '.nii,1']);
            elseif j > 999
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/ECT/ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol' num2str(j) '.nii,1']);
            end
        end  

    elseif cohort == 2
        cd /Volumes/Data/Non-ECT
        matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(subjnum(1,i)) '/visit-1/spm/' char(directory)]); 
        for j = 0:numscans(1,i)
            if j <= 9
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol000' num2str(j) '.nii,1']);
            elseif j > 9 && j <= 99
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol00' num2str(j) '.nii,1']);
            elseif j > 99 && j <= 999
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol0' num2str(j) '.nii,1']);
            elseif j > 999
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(subjnum(1,i)) '/visit-1/func/swvol' num2str(j) '.nii,1']);
            end
        end 

        
    elseif cohort == 3
        cd /Volumes/Data/No-depression
        matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(['/Volumes/Data/No-depression/No-depression_' num2str(subjnum(1,i)) '/VISIT_1/spm/' char(directory)]); 
        for j = 0:numscans(1,i)
            if j <= 9
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/No-depression/No-depression_' num2str(subjnum(1,i)) '/visit-1/func/swvol000' num2str(j) '.nii,1']);
            elseif j > 9 && j <= 99
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/No-depression/No-depression_' num2str(subjnum(1,i)) '/visit-1/func/swvol00' num2str(j) '.nii,1']);
            elseif j > 99 && j <= 999
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/No-depression/No-depression_' num2str(subjnum(1,i)) '/visit-1/func/swvol0' num2str(j) '.nii,1']);
            elseif j > 999
                matlabbatch{1}.spm.stats.fmri_spec.sess.scans(j+1,1) = cellstr(['/Volumes/Data/No-depression/No-depression_' num2str(subjnum(1,i)) '/visit-1/func/swvol' num2str(j) '.nii,1']);
            end
        end
    end
    
    %% Regressors for Outcome PEs 
    cond = cond + 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).name     = 'Outcome PE Events';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).onset    = RegressorsV1{i,1}.Outcome.onset;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).tmod     = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(1).name = 'ev_chosen_pos';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(1).param = zscore(RegressorsV1{i,1}.ev_chosen_pos);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(1).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(2).name = 'ev_unchosen_pos';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(2).param = zscore(RegressorsV1{i,1}.ev_unchosen_pos);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(2).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(3).name = 'pos_RPE';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(3).param = zscore(RegressorsV1{i,1}.pos_RPE);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(3).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(4).name = 'neg_RPE';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(4).param = zscore(RegressorsV1{i,1}.neg_RPE);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(4).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(5).name = 'ev_chosen_neg';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(5).param = zscore(RegressorsV1{i,1}.ev_chosen_neg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(5).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(6).name = 'ev_unchosen_neg';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(6).param = zscore(RegressorsV1{i,1}.ev_unchosen_neg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(6).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(7).name = 'pos_PPE';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(7).param = zscore(RegressorsV1{i,1}.pos_PPE);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(7).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(8).name = 'neg_PPE';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(8).param = zscore(RegressorsV1{i,1}.neg_PPE);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod(8).poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).orth = 0;
    
    %% Regressors for Rating Screen Onset
    cond = cond + 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).name     = 'Rating Onset';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).onset    = RegressorsV1{i,1}.Rating.onset;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).tmod     = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod     = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).orth     = 0;
    
    %% Regressors for Button preses
    cond = cond + 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).name     = 'Buttonpress';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).onset    = RegressorsV1{i,1}.Buttonpress;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).tmod     = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod     = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).orth     = 0;

    %% Regressors for Screen Changes 
    cond = cond + 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).name     = 'Screen Changes';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).onset    = RegressorsV1{i,1}.Outcome.offset;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).tmod     = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).pmod     = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(cond).orth     = 0;
    
    %% Other Model Specifics
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi   = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    if cohort == 1
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(['/Volumes/Data/ECT/ECT_' num2str(subjnum(1,i)) '/visit-1/func/rp_vol0000.txt']);
    elseif cohort == 2
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(subjnum(1,i)) '/visit-1/func/rp_vol0000.txt']);
    elseif cohort == 3
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(['/Volumes/Data/No-depression/No-depression_' num2str(subjnum(1,i)) '/visit-1/func/rp_vol0000.txt']);
    end 
            
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf         = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact             = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt             = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global           = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh          = 0.8;
%     matlabbatch{1}.spm.stats.fmri_spec.mask             = {'/Users/Documents/MATLAB/toolboxes/spm12/toolbox/FieldMap/brainmask.nii'};
    matlabbatch{1}.spm.stats.fmri_spec.mask             = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi              = 'AR(1)';
    
    
    %% Define Contrasts
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1)        = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals  = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1)             = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    con_names_orig = {'Outcome Onset', 'Qchosen_pos', 'Qunchosen_pos', 'pos_RPE', 'neg_RPE', 'Qchosen_neg', 'Qunchosen_neg', 'pos_PPE', 'neg_PPE','Rating Screen', 'Buttonpresses', 'Screen changes'};

    con_names_F    = struct([]);
    con_names_tpos = struct([]);
    con_names_tneg = struct([]);
    for name = 1:size(con_names_orig,2)
        con_names_F{1,name}    = [con_names_orig{1,name} '_F'];
        con_names_tpos{1,name} = [con_names_orig{1,name} '_Tpos'];
        con_names_tneg{1,name} = [con_names_orig{1,name} '_Tneg'];
    end
    con_mat = [ [eye(size(con_names_orig,2)) zeros(size(con_names_orig,2),6)] ; [eye(size(con_names_orig,2)) zeros(size(con_names_orig,2),6)] ; [-1*eye(size(con_names_orig,2)) zeros(size(con_names_orig,2),6)] ];
    con_names = [con_names_F con_names_tpos con_names_tneg];
    for idx = 1:size(con_names,2)
        if idx < size(con_names_orig,2)+1
            matlabbatch{3}.spm.stats.con.consess{idx}.fcon.name    = char(con_names(idx));
            matlabbatch{3}.spm.stats.con.consess{idx}.fcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{idx}.fcon.weights = con_mat(idx,:);
        else
            matlabbatch{3}.spm.stats.con.consess{idx}.tcon.name    = char(con_names(idx));
            matlabbatch{3}.spm.stats.con.consess{idx}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{idx}.tcon.weights = con_mat(idx,:);
        end
    end

                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+1}.tcon.name    = char('Pos EVs');
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+1}.tcon.sessrep = 'none';
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+1}.tcon.weights = [0 1 1 0 0 0 0 0 0 0 0 0];
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+2}.tcon.name    = char('RPEs');
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+2}.tcon.sessrep = 'none';
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+2}.tcon.weights = [0 0 0 1 1 0 0 0 0 0 0 0];
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+3}.tcon.name    = char('Neg EVs');
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+3}.tcon.sessrep = 'none';
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+3}.tcon.weights = [0 0 0 0 0 1 1 0 0 0 0 0];
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+4}.tcon.name    = char('PPEs');
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+4}.tcon.sessrep = 'none';
                matlabbatch{3}.spm.stats.con.consess{size(con_names,2)+4}.tcon.weights = [0 0 0 0 0 0 0 1 1 0 0 0];

    matlabbatch{3}.spm.stats.con.delete = 0;

    inputs = cell(0, nrun);
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    spm_jobman('run', matlabbatch, inputs{:});  
end
