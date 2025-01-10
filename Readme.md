# QUICK-GCP-LAB-With-Terraform

This repository provides a quick and easy way to set up and manage Google Cloud Platform (GCP) resources using Terraform. It is designed for learning, experimentation, and rapid prototyping in GCP.

## Features

- Automates the creation of GCP resources.
- Modular and reusable Terraform configurations.
- Quick setup for GCP labs and testing environments.
- Easy-to-follow structure for beginners and advanced users.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- A GCP account with billing enabled.
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and authenticated.
- A GCP project created and set as the active project.

## Usage

1. Clone the repository:
    ```bash
    git clone https://github.com/bhowmickkrishnendu/QUICK-GCP-LAB-With-Terraform.git
    cd QUICK-GCP-LAB-With-Terraform
    ```

2. Initialize Terraform:
    ```bash
    terraform init
    ```

3. Review and customize the `variables.tf` file to match your GCP setup.

4. Apply the Terraform configuration:
    ```bash
    terraform apply
    ```

5. Confirm the changes and wait for the resources to be provisioned.

6. To destroy the resources when done:
    ```bash
    terraform destroy
    ```

## Structure

- `main.tf`: Main Terraform configuration file.
- `variables.tf`: Input variables for customization.
- `outputs.tf`: Outputs for the created resources.
- `README.md`: Documentation for the repository.

## Notes

- Ensure you have sufficient permissions in your GCP account to create and manage resources.
- Use this repository responsibly to avoid unexpected charges in your GCP account.

## License

This project is licensed under the [MIT License](LICENSE).

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests.

## Disclaimer

This repository is intended for educational purposes only. Use it at your own risk.