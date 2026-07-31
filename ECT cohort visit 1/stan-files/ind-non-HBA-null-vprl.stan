// int<lower=1, upper=2> num_X
// sets the variable num_X to some integer between 1 and 2.

data {
  int<lower=1> num_subjects; //number of subjects
  int<lower=1> num_trials; //number of trials
  int<lower=1, upper=6> option1[num_subjects, num_trials]; //icon grouping for option1
  int<lower=1, upper=6> option2[num_subjects, num_trials]; //icon grouping for option2
  int<lower=1, upper=2> choice[num_subjects, num_trials]; //choice
  real outcome_pos[num_subjects, num_trials]; //actual amount gained
  real outcome_neg[num_subjects, num_trials]; //actual amount lost
}

transformed data {
  row_vector[3] initV;
  initV = rep_row_vector(0.0, 3);
}
//what do you want it to fit
parameters {
  // Subject-level raw parameters
  vector<lower=0, upper=1>[num_subjects] learnrate_pos_pr;
  vector<lower=0, upper=1>[num_subjects] learnrate_neg_pr;
  vector<lower=0, upper=1>[num_subjects] discount_pos_pr;
  vector<lower=0, upper=1>[num_subjects] discount_neg_pr;
  vector<lower=0, upper=20>[num_subjects] tau_pr;
}

transformed parameters {
  // subject-level parameters
  vector<lower=0, upper=1>[num_subjects] learnrate_pos;
  vector<lower=0, upper=1>[num_subjects] learnrate_neg;
  vector<lower=0, upper=1>[num_subjects] discount_pos;
  vector<lower=0, upper=1>[num_subjects] discount_neg;
  vector<lower=0, upper=20>[num_subjects] tau;

for (i in 1:num_subjects) {
    learnrate_pos[i] = Phi_approx(learnrate_pos_pr[i]);
    learnrate_neg[i] = Phi_approx(learnrate_neg_pr[i]);
    discount_pos[i]  = Phi_approx(discount_pos_pr[i]);
    discount_neg[i]  = Phi_approx(discount_neg_pr[i]);
    tau[i] 	    = Phi_approx(tau_pr[i])*20;
  }
}


model {
  //define priors on indidivual parameters
  learnrate_pos_pr  ~ uniform(0,1);
  learnrate_neg_pr  ~ uniform(0,1);
  discount_pos_pr   ~ uniform(0,1);
  discount_neg_pr   ~ uniform(0,1);
  tau_pr            ~ uniform(0,20);

  // subject loop and trial loop
  for (i in 1:num_subjects) {

    // create matrix of expected values for [icon, phase]
    matrix[6,3] ev_pos;
    matrix[6,3] ev_neg;
    matrix[6,3] ev_sum;
    int decision; // define decision
    real PE_pos; // positive prediction error //+ or -RPE (depending on actual vs expected)
    real PE_neg; // negative prediction error // + or -PPE (depending on actual vs expected)
    vector[2] option_values = [ 0, 0 ]';

    // for each icon, set the initial expected value
    // equal to initV (0.0)
    for (idx in 1:6) {
      ev_pos[idx] = initV;
      ev_neg[idx] = initV;
      ev_sum[idx] = initV;
    }

    // For each trial
    for (t in 1:num_trials) {

      // If the subject's choice for this trial is greater than 1,
      // set decision = option2. Otherwise, set decision = option1.
      decision = (choice[i, t] > 1) ? option2[i, t] : option1[i, t];

      // ????
      option_values = [ ev_sum[option1[i, t], 1] , ev_sum[option2[i, t], 1] ]'; //expected value of left and right

      // compute action probabilities
      target += categorical_lpmf(choice[i,t] | softmax( option_values*tau[i] )); //

      // The outcome is seen on the 3rd episode of the PRP/IAPS task. So, the outcome
      // only factors into the updating when it's the 3rd episode. (episodes: option selection, action, outcome; so below we are getting RPE and updated
      // Q-value from these three episodes in total (the option and outcome first then after else the outcome presentation when you actually get the delivered reward))
      for (e in 1:3) {

        if (e < 3) {
          // prediction error and value updating for outcome_pos
          PE_pos = discount_pos[i] * ev_pos[decision, e+1] - ev_pos[decision, e]; //+RPE
          ev_pos[decision, e] += learnrate_pos[i] * PE_pos; //value update (updating Q-value here based on RPE and learning rate! same below)

          // prediction error and value updating for ourcome_neg
          PE_neg = discount_neg[i] * ev_neg[decision, e+1] - ev_neg[decision, e];
          ev_neg[decision, e] += learnrate_neg[i] * PE_neg;

          // contrast expected value
          ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e]; //compositite Q-value


        } else {
          // update using outcome_pos
          PE_pos = outcome_pos[i, t] - ev_pos[decision, e];
          ev_pos[decision, e] += learnrate_pos[i] * PE_pos;

          // update using outcome_neg
          PE_neg = outcome_neg[i, t] - ev_neg[decision, e];
          ev_neg[decision, e] += learnrate_neg[i] * PE_neg;

          // contrast expected value
          ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];

        } // outcome valence if-else loop
      } // episode loop
    } // trial loop
  } // individual loop
}

generated quantities {
  // For log-likelihood values and posterior predictive check
  real log_lik[num_subjects];
  real y_pred[num_subjects,num_trials];

  // Set all posterior predictions to -1 (avoids num_subjectsULL values)
  for (i in 1:num_subjects) {
    for (t in 1:num_trials) {
      y_pred[i,t] = -1;
    }
  }
   // subject loop and trial loop
    for (i in 1:num_subjects) {

      // create matrix of expected values for [icon, phase]
      matrix[6,3] ev_pos;
      matrix[6,3] ev_neg;
      matrix[6,3] ev_sum;
      int decision; // define decision
      real PE_pos; // positive prediction error
      real PE_neg; // negative prediction error
      vector[2] option_values = [ 0, 0 ]'; // ????

      log_lik[i] = 0;

      // for each icon, set the initial expected value
      // equal to initV (0.0)
      for (idx in 1:6) {
        ev_pos[idx] = initV;
        ev_neg[idx] = initV;
        ev_sum[idx] = initV;
      }

      // For each trial
      for (t in 1:num_trials) {

        // If the subject's choice for this trial is greater than 1,
        // set decision = option2. Otherwise, set decision = option1.
        decision = (choice[i, t] > 1) ? option2[i, t] : option1[i, t];

        // 2 element vector where the expected value for that person and trial
        // of each option presented on the trial
        // the comma 1 is for indicating the specific episode (option presentation)
        option_values = [ ev_sum[option1[i, t], 1] , ev_sum[option2[i, t], 1] ]';

        // compute action probabilities

        log_lik[i] += categorical_lpmf(choice[i, t] | softmax( option_values*tau[i] ));

        // compute posterior predicted choice
        y_pred[i,t] += categorical_rng( softmax( option_values*tau[i] ));


        // The outcome is seen on the 3rd episode of the PRP and IAPS task. So, the outcome
        // only factors in to the updating when it's the 3rd episode.
        for (e in 1:3) {

          if (e < 3) {
            // prediction error and value updating for outcome_pos
            PE_pos = discount_pos[i] * ev_pos[decision, e+1] - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;

            // prediction error and value updating for ourcome_neg
            PE_neg = discount_neg[i] * ev_neg[decision, e+1] - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;

            // contrast expected values
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];


          } else {
            // update using outcome_pos
            PE_pos = outcome_pos[i, t] - ev_pos[decision, e];
            ev_pos[decision, e] += learnrate_pos[i] * PE_pos;

            // update using outcome_neg
            PE_neg = outcome_neg[i, t] - ev_neg[decision, e];
            ev_neg[decision, e] += learnrate_neg[i] * PE_neg;

            // contrast expected values
            ev_sum[decision, e] = ev_pos[decision, e] - ev_neg[decision, e];

          } // outcome valence if-else loop
        } // episode loop
      } // trial loop
    } // individual loop
  }



