# MATLAB based Stock Prediction

## Project Overview
This project aims to predict future stock returns using historical stock data. It utilizes MATLAB for data processing and machine learning modeling, offering insights into future market trends.

## Repository Structure

```
├── src/
│ ├── porfolio # 
│ └── options/ # 
├── stock_prediction/
│ └── data/ # training data
│ └── models/ # output models
│ └── log/ #trianing log
│ ── predict/
│     └── predict_scripts.m # prediction scripts
│     └── predit_x.mat # prediction independent variable
│ ── utils/
│     └── load_data.m # data loading scripts
│     └── process_wkretrun.m # preocess data calculate retrun
│ ── scripts/
│     └── ..... / # previous scripts
│ └── data_loader.m # data loading scripts
│ └── train_model.m # modeling training scripts
│ └── training_pipeline.m # training pipeline
└── README.md
```

## Quick Start
To run this project, MATLAB installation is required with the latest Statistical and Machine Learning Toolbox.

### Training overview

1. Run `training_pipeline.m` to load the data and execute model training.
2. Execute `predict/predict_scripts.m` to load the trained model and predict the result.

### Data Processing
1. Place your raw stock data files in the `data/` directory.
2. Run `utils/load_data.m` to load the data.
3. Execute `process_wkretrun` to load the raw data and calculate the week return and other secondary index.

### Model Training
1. Execute `scripts/step_training.m` to start training the models.
2. Upon completion, prediction results models will be saved in the `models/` directory.
3. traning log will be recored in training_log.txt

### Model Prediction
1. Execute `predict/predict_x.mat` to load the prediction independent variable.
2. Execute `predict/predict_scripts.m` to load models and predict result.

## Configuration and Dependencies
- MATLAB R202X
- Statistical and Machine Learning Toolbox

## Contributing
Contributions to this project are welcome, whether they be new features, improvements, or bug fixes. Please follow these simple steps:
1. Fork the project.
2. Create your Feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.

## Contact
Ning Wei - allenwei0503@gmail.com
Project Link: (https://github.com/AllenWn/stock_prediction)
Notes:
Repository Structure: Includes a detailed breakdown of where files should be placed within the project's directory structure.
Quick Start: Provides steps to get the project up and running.
Contributing: Encourages other developers to contribute to the project.
License and Contact: Provides licensing information and a way to contact the project maintainer.
