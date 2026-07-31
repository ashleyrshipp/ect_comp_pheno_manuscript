
%% one-sample t-test pooling all participants

clear matlabbatch
nrun = 1;
inputs = cell(0, nrun);
contast_num =25;

%specify scan information for each cohort
scans = cell(104,1);

base_path_ECT = '/Volumes/Data/ECT/';
ECT_subjnumbers = [1:25]; 

base_path_non_ECT = '/Volumes/Data/Non-ECT/';
non_ECT_subjnumbers = [1:38]; 

base_path_no_depression = '/Volumes/Data/No-depression/';
no_depression_subjnumbers = [1:41];

total_subjects_ECT = numel(ECT_subjnumbers);
total_subjects_non_ECT = numel(non_ECT_subjnumbers);
total_subjects_no_depression = numel(no_depression_subjnumbers);

scans = cell(total_subjects_ECT + total_subjects_non_ECT + total_subjects_no_depression, 1);

% Loop for pre-ECT cohort
for i = 1:total_subjects_ECT
    subject_path = fullfile(base_path_ECT, ['ECT_' num2str(ECT_subjnumbers(i))]);
    scan_path = fullfile(subject_path, 'visit-1', 'spm', 'v1_vprl_glm', ['con_00' num2str(contast_num) '.nii,1']);
    scans{i} = scan_path;
end

% Loop for non-ECT cohort
for i = 1:total_subjects_non_ECT
    subject_path = fullfile(base_path_non_ECT, ['Non-ECT_' num2str(non_ECT_subjnumbers(i))]);
    scan_path = fullfile(subject_path, 'visit-1', 'spm', 'v1_vprl_glm', ['con_00' num2str(contast_num) '.nii,1']);
    scans{total_subjects_ECT + i} = scan_path;
end

% Loop for Healthy cohort
for i = 1:total_subjects_no_depression
    subject_path = fullfile(base_path_no_depression, ['No-depression' num2str(H_subjnumbers(i))]);
    scan_path = fullfile(subject_path, 'visit-1', 'spm', 'v1_vprl_glm', ['con_00' num2str(contast_num) '.nii,1']);
    scans{total_subjects_ECT + total_subjects_non_ECT + i} = scan_path;
end
 
matlabbatch{1}.spm.stats.factorial_design.dir = {'/Volumes/Data/second_level_tests/one_sample_t_test/all_participants/v1_vprl_glm/negPPE'};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = scans; 
% 
% matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [T.MOCA]
% matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'MOCA';
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
% 
% matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [T.Age]
% matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Age';
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
% 
% matlabbatch{1}.spm.stats.factorial_design.cov(2).c = [T.Gender]
% matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'Gender';
% matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
% 
% matlabbatch{1}.spm.stats.factorial_design.cov(3).c = [T.HAMD]
% matlabbatch{1}.spm.stats.factorial_design.cov(3).cname = 'HAMD';
% matlabbatch{1}.spm.stats.factorial_design.cov(3).iCC = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov(3).iCFI = 1;

matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch, inputs{:});
% spm fmri 