%% VPRL ANOVA - Visit 1

clear matlabbatch

nrun = 1;
inputs = cell(0, nrun);
contast_num = 25;
ECT_subjnumbers = [1:25]; 
non_ECT_subjnumbers = [1:38];
no_depression_subjnumbers = [1:41];

matlabbatch{1}.spm.stats.factorial_design.dir = {'/Volumes/Data/second_level_tests/anova/v1_vprl_glm/negPPE'};

for j = 1:size(ECT_subjnumbers,2)
matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(1).scans(j,1) = cellstr(['/Volumes/Data/ECT/ECT_' num2str(ECT_subjnumbers(1,j)) '/visit-1/spm/v1_vprl_glm/con_00' num2str(contast_num) '.nii,1']);
end 

for k = 1:size(non_ECT_subjnumbers,2)
matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(2).scans(k,1) = cellstr(['/Volumes/Data/Non-ECT/Non-ECT_' num2str(Dep_subjnumbers(1,k)) '/visit-1/spm/v1_vprl_glm/con_00' num2str(contast_num) '.nii,1']);
end
for l = 1:size(no_depression_subjnumbers,2)
matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(3).scans(l,1) = cellstr(['/Volumes/Data/No-depression/No-depression_' num2str(H_subjnumbers(1,l)) '/visit-1/spm/v1_vprl_glm/con_00' num2str(contast_num) '.nii,1']);
end

matlabbatch{1}.spm.stats.factorial_design.des.anova.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anova.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anova.gmsca = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anova.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
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