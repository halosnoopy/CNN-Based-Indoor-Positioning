# CNN-Based-Indoor-Positioning

## Overview
This computer vision project models the **indoor positioning problem** as an **image recognition task**. 
Instead of directly regressing continuous coordinates, the spatial environment is divided into discrete blocks, and localization is formulated as a **classification problem**. 
Wi-Fi signal fingerprints are transformed into image-like matrices that preserve spatial and signal structure, and a **Convolutional Neural Network (CNN)** is trained to classify each image into its corresponding area, floor, and building.

This approach simplifies coordinate regression, improves learning stability, and demonstrates the potential of computer vision methods for indoor positioning using Wi-Fi Received Signal Strength (RSS) fingerprints.

---

## Motivation
Traditional Global Navigation Satellite Systems (GNSS) fail indoors due to signal blockage and multipath effects. 
RSS fingerprinting offers a cost-effective alternative because Wi-Fi access points are already widely deployed. 
However, RSS measurements fluctuate significantly, degrading positioning accuracy.  
This project applies deep learning — specifically **CNNs** — to learn robust spatial patterns from RSS fingerprints and to perform indoor localization with high accuracy in multi-building, multi-floor environments.

---

## Dataset
The project uses the **UJIIndoorLoc** dataset, a public multi-building, multi-floor Wi-Fi fingerprint database widely used in indoor localization research.

- **520 Wi-Fi Access Points (APs)** per sample  
- **Features:** RSS values, coordinates (X, Y), floor number, building number, timestamp  
- **Training samples:** 199,937  
- **Testing samples:** 1,111  

RSS values range from -140 dBm to 0 dBm, and +100 indicates a missing AP (replaced by -100 dBm in this project).

---

## Methodology

### 1. Data Preprocessing
Each Wi-Fi fingerprint (520 RSS features) is converted into a 2D image-like structure for CNN input:
- The dataset is divided into grids based on (X, Y) coordinates.
- Each grid represents a spatial block (area).
- A sliding window is applied across time to generate image samples per grid.
- Each image is labeled with its **building**, **floor**, and **area** number.

This process reformulates RSS-based localization into a **multi-class image classification** task.

### 2. Model Architecture
The project employs several CNN architectures designed and trained in **MATLAB Deep Learning Toolbox**:
- **Convolutional layers:** extract spatial signal patterns  
- **Activation:** ReLU  
- **Pooling:** Max pooling to reduce feature dimensionality  
- **Fully connected layers:** perform classification  
- **Output layer:** SoftMax (multi-class prediction)  

Optimizers used include **Adam** and **Stochastic Gradient Descent (SGD)** with learning rate 0.01.  

---

## Positioning System Design
The complete indoor localization system includes **three CNN models**:

1. **Building Prediction Model**  
   Classifies the building number (3 classes).  
2. **Floor Prediction Model**  
   Predicts the floor number within each building (5 classes).  
3. **Area (Block) Prediction Model**  
   Predicts the user’s grid or area ID (370 classes).

**Offline phase:** models are trained using the processed image dataset.  
**Online phase:** a new RSS sequence is transformed into an image and passed through all three CNN models to estimate the user’s location (building → floor → area).

---

## Experimental Results

| Task | Best Accuracy |
|------|----------------|
| **Building Prediction** | 100% |
| **Floor Prediction** | 99.96% |
| **Area (Block) Prediction** | 89.59% |

**Average localization error:** 2.49 m  


---

## Project File Structure

├── data\_processing/

│ ├── data\_analyst.m # Analyze dataset before preprocessing

│ ├── data\_process\_to\_images.m # Convert static RSS signals into image-like matrices

│ ├── train\_test\_split\_CNN.m # Split dataset into training and testing sets

│ ├── data\_to\_train\_CNN.m # Assign block number labels within each building

│ ├── make\_label\_370blocks.m # Refine and correct block labeling

│ ├── dictionary\_to\_match\_block.m # Create hash table for coordinate-query matching



├── model\_training/

│ ├── Building\_pred\_test.m # CNN model for building classification

│ ├── Floor\_pred\_test.m # CNN model for floor classification

│ ├── Block\_pred\_test.m # CNN model for block (area) classification



├── simulation\_positioning\_process/

│ ├── demo.m # Visualization of the localization process



├── function/

│ └── (Custom functions used by the above scripts)

