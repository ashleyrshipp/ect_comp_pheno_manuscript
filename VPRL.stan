data {
  int<lower=1> N; // number of subjects
  int<lower=1> T; // number of trails
  array[N] int<lower=1, upper=T> T_subjs; // trials per subject
  array[N, T] int<lower=-1, upper=60> option1; // option 1 presented per trial for each subject
  array[N, T] int<lower=-1, upper=60> option2; // option 2 presented per trial for each subject
  array[N, T] int<lower=-1, upper=2> choice; // choice per trial for each subject
  array[N, T] real outcome; // actual outcome
  // array[N, T] real reward; // actual reward per trial for each subject
  // array[N, T] real punish; // actual punishment per trial for each subject
}

transformed data {
  row_vector[3] initV;
  initV = rep_row_vector(0.0, 3);
}

parameters {
  // Hyper(group)-parameters
  vector[5] mu_pr;
  vector<lower=0>[5] sigma_pr;

  // Subject-level raw parameters
  vector[N] learnrate_pos_pr;
  vector[N] learnrate_neg_pr;
  vector[N] discount_pos_pr;
  vector[N] discount_neg_pr;
  vector[N] tau_pr;
}

transformed parameters {
  // subject-level parameters
  vector<lower=0, upper=1>[N] learnrate_pos;
  vector<lower=0, upper=1>[N] learnrate_neg;
  vector<lower=0, upper=1>[N] discount_pos;
  vector<lower=0, upper=1>[N] discount_neg;
  vector<lower=0, upper=20>[N] tau;

  for (i in 1:N) {
    learnrate_pos[i] = Phi_approx(mu_pr[1] + sigma_pr[1] * learnrate_pos_pr[i]);
    learnrate_neg[i] = Phi_approx(mu_pr[2] + sigma_pr[2] * learnrate_neg_pr[i]);
    discount_pos[i]  = Phi_approx(mu_pr[3] + sigma_pr[3] * discount_pos_pr[i]);
    discount_neg[i]  = Phi_approx(mu_pr[4] + sigma_pr[4] * discount_neg_pr[i]);
    tau[i] 	         = Phi_approx(mu_pr[5] + sigma_pr[5] * tau_pr[i])*20;
  }
}

model {
  // Hyperparameters
  mu_pr     ~ normal(0,1);
  sigma_pr  ~ normal(0,1);

  // individual parameters
  learnrate_pos_pr  ~ normal(0,1);
  learnrate_neg_pr  ~ normal(0,1);
  discount_pos_pr   ~ normal(0,1);
  discount_neg_pr   ~ normal(0,1);
  tau_pr            ~ normal(0,1);

  // subject loop and trial loop
  for (i in 1:N) {
    matrix[6,3] ev_pos; 		
    matrix[6,3] ev_neg;
    matrix[6,3] ev_sum;
    int decision; 		
    real PE_pos;
    real PE_neg;
    vector[2] option_values = [ 0, 0 ]';

    for (idx in 1:6) {
      ev_pos[idx] = initV;
      ev_neg[idx] = initV;
      ev_sum[idx] = initV;
    }
          
    for (t in 1:T_subjs[i]) {
            
      decision = (choice[i, t] > 1) ? option2[i, t] : option1[i, t];

      option_values = [ ev_sum[option1[i, t], 1] , ev_sum[option2[i, t], 1] ]';

      // compute action probabilities
      target += categorical_lpmf(choice[i,t] | softmax( option_values* (1/tau[i]) ));

      for (e in 1:3) {
        	
      	if (outcome[i, t] > 0) {

	  if (e < 3) {
            // prediction error and value updating
            PE_pos = discount_pos[i] * ev_pos[decision, e+1] - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
          } else {
            PE_pos = abs(outcome[i, t]) - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
          }

	} else if (outcome[i, t] < 0) {

	  if (e < 3) {
            // prediction error and value updating for first trial episode
            PE_neg = discount_neg[i] * ev_neg[decision, e+1] - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  } else {
	    // prediction error and value updating for first trial episode
            PE_neg = abs(outcome[i, t]) - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  }

        } else {

	  if (e < 3) {
            PE_pos = discount_pos[i] * ev_pos[decision, e+1] - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            PE_neg = discount_neg[i] * ev_neg[decision, e+1] - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  } else {
            PE_pos = 0 - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            PE_neg = 0 - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  }
        } // outcome valence if-else statement
      } // episode loop
    } // trial loop
  } // individual loop
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_learnrate_pos;
  real<lower=0, upper=1> mu_learnrate_neg;
  real<lower=0, upper=1> mu_discount_pos;
  real<lower=0, upper=1> mu_discount_neg;
  real<lower=0, upper=20> mu_tau;   

  // For log-likelihood values and posterior predictive check
  array[N] real log_lik;
  array[N,T] real y_pred;

  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i,t] = -1;
    }
  }
           
  mu_learnrate_pos  = Phi_approx(mu_pr[1]);
  mu_learnrate_neg  = Phi_approx(mu_pr[2]);
  mu_discount_pos   = Phi_approx(mu_pr[3]);
  mu_discount_neg   = Phi_approx(mu_pr[4]);
  mu_tau	          = Phi_approx(mu_pr[5])*20;

  { for (i in 1:N) {
     
    matrix[6,3] ev_pos;
    matrix[6,3] ev_neg; 		
    matrix[6,3] ev_sum; 
    int decision; 				
    real PE_pos;
    real PE_neg;
    vector[2] option_values = [ 0, 0 ]';

    log_lik[i] = 0;

    for (idx in 1:6) {
      ev_pos[idx] = initV;
      ev_neg[idx] = initV;
      ev_sum[idx] = initV;
    }

    for (t in 1:T_subjs[i]) {

      decision = (choice[i, t] > 1) ? option2[i, t] : option1[i, t];
            
      option_values = [ ev_sum[option1[i, t], 1] , ev_sum[option2[i, t], 1] ]';

      // compute action probabilities
      log_lik[i] += categorical_lpmf(choice[i, t] | softmax( option_values* (1/tau[i]) ));

      // compute posterior predicted choice 
      y_pred[i,t] = categorical_rng( softmax( option_values* (1/tau[i]) ));

      for (e in 1:3) {

if (outcome[i, t] > 0) {

	  if (e < 3) {
            PE_pos = discount_pos[i] * ev_pos[decision, e+1] - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  } else {
            PE_pos = abs(outcome[i, t]) - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  }

	} else if (outcome[i, t] < 0) {

	  if (e < 3) {
            PE_neg = discount_neg[i] * ev_neg[decision, e+1] - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  } else {
            PE_neg = abs(outcome[i, t]) - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  }

        } else {

	  if (e < 3) {
            PE_pos = discount_pos[i] * ev_pos[decision, e+1] - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            PE_neg = discount_neg[i] * ev_neg[decision, e+1] - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  } else {
            PE_pos = 0 - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;
            PE_neg = 0 - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];
	  }
        } // outcome valence if-else statement
        } // episode loop
      }  // trial loop
    }  // individual loop
  }  // local section
}