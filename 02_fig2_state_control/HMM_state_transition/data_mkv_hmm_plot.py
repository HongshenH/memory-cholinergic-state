# process file using HMM 

import autograd.numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from scipy.stats import multivariate_normal
import seaborn as sns
import matplotlib.pyplot as plt
import os
from sklearn.preprocessing import MinMaxScaler
from hmmlearn import hmm
import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import Axes3D


def hmm_process(df, csv_file_name, output_folder_path, save_figures=True):
    # Create a subfolder with the name of the CSV file
    subfolder_name = os.path.splitext(os.path.basename(csv_file_name))[0]
    subfolder_path = os.path.join(output_folder_path, subfolder_name)

    if not os.path.exists(subfolder_path):
        os.makedirs(subfolder_path)
        
    # Extracted features and Laser_marker
    features = ["Theta", "Rip", "Rip_occ", "Laser_marker"]
    X = df[features].values
    laser_marker = df["Laser_marker"].values
    no_trans_Laser = df["no_trans_Laser"].values

    # Identify indices of "0000" and "1111" chunks
    start_0000 = np.where((laser_marker == 0) & (np.roll(laser_marker, 1) != 0))[0]
    start_1111 = np.where((laser_marker == 1) & (np.roll(laser_marker, 1) != 1))[0]

    # Initialize arrays to store normalized Theta values
    norm_theta = np.ones_like(laser_marker, dtype=float)

    # Calculate average Theta values and normalize corresponding "1111" chunks
    for start_0000_idx, start_1111_idx in zip(start_0000, start_1111):
        end_0000_idx = np.where(laser_marker[start_0000_idx:] != 0)[0][0] + start_0000_idx
        end_1111_idx = np.where(laser_marker[start_1111_idx:] != 1)[0][0] + start_1111_idx

        # Extract Theta values for "0000" and "1111" chunks
        theta_0000 = X[start_0000_idx:end_0000_idx, 0]
        theta_1111 = X[start_1111_idx:end_1111_idx, 0]

        # Calculate average Theta values
        avg_theta_0000 = np.mean(theta_0000)

        norm_theta[start_0000_idx:end_0000_idx] = theta_0000 / avg_theta_0000
        norm_theta[start_1111_idx:end_1111_idx] = theta_1111 / avg_theta_0000

    df['norm_theta'] = norm_theta
    
    # Initialize arrays to store normalized Theta values
    norm_ripple = np.ones_like(laser_marker, dtype=float)

    # Calculate average Theta values and normalize corresponding "1111" chunks
    for start_0000_idx, start_1111_idx in zip(start_0000, start_1111):
        end_0000_idx = np.where(laser_marker[start_0000_idx:] != 0)[0][0] + start_0000_idx
        end_1111_idx = np.where(laser_marker[start_1111_idx:] != 1)[0][0] + start_1111_idx

        # Extract Theta values for "0000" and "1111" chunks
        ripple_0000 = X[start_0000_idx:end_0000_idx, 1]
        ripple_1111 = X[start_1111_idx:end_1111_idx, 1]

        # Calculate average Theta values
        avg_ripple_0000 = np.mean(ripple_0000)

        norm_ripple[start_0000_idx:end_0000_idx] = ripple_0000 / avg_ripple_0000
        norm_ripple[start_1111_idx:end_1111_idx] = ripple_1111 / avg_ripple_0000

    df['norm_ripple'] = norm_ripple
    
    selected_rows = df[(df['Laser_marker'].isin([0, 1])) & (df['prctile_50'] == 1)]
    features_sel = ['norm_theta', 'norm_ripple', 'Rip_occ']
    X_sel = selected_rows[features_sel].values
    laser_marker = selected_rows['Laser_marker'].values
    scaler = StandardScaler()
    X_normalized = scaler.fit_transform(X_sel)

    # Create an HMM model
    n_states = 3
    model = hmm.GaussianHMM(n_components=n_states, covariance_type="full", random_state=42)

    model.fit(X_normalized)
    hidden_states = model.predict(X_normalized)
    selected_rows['hidden_state'] = hidden_states

    means = model.means_
    covariances = model.covars_

    emission_probs = np.zeros((len(features_sel), n_states))

    for j in range(len(features_sel)):
        for i in range(n_states):
            feature_mean = means[i, j]
            feature_covariance = covariances[i, j, j]  
            prob_values = multivariate_normal.pdf(X_normalized[:, j], mean=feature_mean, cov=feature_covariance)
            emission_probs[j, i] = prob_values.mean()  

    emission_probs /= emission_probs.sum(axis=1, keepdims=True)
    emission_df = pd.DataFrame(emission_probs, columns=[f'State {i}' for i in range(n_states)], index=features_sel)
    emission_probs_normalized = np.zeros_like(emission_probs)

    for i in range(n_states):
        state_probs = emission_probs[:, i]
        state_probs_normalized = state_probs / state_probs.sum()
        emission_probs_normalized[:, i] = state_probs_normalized

    emission_df_normalized = pd.DataFrame(emission_probs_normalized, columns=[f'State {i}' for i in range(n_states)], index=features_sel)

    theta_dominant_states = emission_df_normalized.loc['norm_theta'].idxmax()
    ripple_dominant_states = emission_df_normalized.loc['norm_theta'].idxmin()

    theta_dominant_state = int(theta_dominant_states.split()[1])
    ripple_dominant_state = int(ripple_dominant_states.split()[1])

    # Create a marker array
    markers = np.ones(n_states) * 3  
    markers[theta_dominant_state] = 1  
    markers[ripple_dominant_state] = 2  

    marker_df = pd.DataFrame([markers], columns=[f'State {i}' for i in range(n_states)], index=['Marker_name'])
    marker_num = pd.DataFrame([markers], columns=[f'State {i}' for i in range(n_states)], index=['Marker_sign'])
    marker_names = {
        1: 'Theta_dominant',
        2: 'Ripple_dominant',
        3: 'Idle'
    }

    marker_df_names = marker_df.replace({col: marker_names for col in marker_df.columns})
    emission_df_with_markers = pd.concat([emission_df_normalized, marker_num, marker_df_names])
        
    def extract_transition_matrix(hidden_states):
        n_states = model.n_components
        transmat = np.zeros((n_states, n_states))
        for i in range(len(hidden_states) - 1):
            transmat[hidden_states[i], hidden_states[i + 1]] += 1
        # Check for zero sum to avoid division by zero
        row_sums = transmat.sum(axis=1, keepdims=True)
        transmat /= np.where(row_sums == 0, 1, row_sums)
        return transmat


    transmat_all = extract_transition_matrix(hidden_states[(selected_rows['Laser_marker'] == 1) | (selected_rows['Laser_marker'] == 0)])
    transmat_condition1 = extract_transition_matrix(hidden_states[selected_rows['Laser_marker'] == 0])
    transmat_condition2 = extract_transition_matrix(hidden_states[selected_rows['Laser_marker'] == 1])

    def compare_matrices(matrix1, matrix2):
        norm_difference = np.linalg.norm(matrix1 - matrix2)
        return norm_difference

    frobenius_difference = compare_matrices(transmat_condition1, transmat_condition2)

    desired_order = ['Theta_dominant', 'Idle', 'Ripple_dominant']

    marker_names = emission_df_with_markers.loc['Marker_name'].values

    state_mapping = {marker: idx for idx, marker in enumerate(desired_order)}
    mapped_order = [state_mapping[marker] for marker in marker_names]

    transmat_condition1_ordered = transmat_condition1[:, mapped_order][mapped_order, :]
    transmat_condition2_ordered = transmat_condition2[:, mapped_order][mapped_order, :]

    return emission_df_normalized, emission_df_with_markers, transmat_condition1, transmat_condition2, frobenius_difference, transmat_condition1_ordered, transmat_condition2_ordered, transmat_all