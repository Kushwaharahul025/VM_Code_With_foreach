name: "Dev Terraform Workflow"

on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main      

permissions:
  id-token: write
  contents: read
  
jobs: 
  terraform-init-plan:
    runs-on: runkro
    steps: 
      - name: Checkout
        uses: actions/checkout@v5.0.0
    
      - name: Azure Login
        uses: Azure/login@v2.3.0
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
            
      - name: Terraform fmt
        id: fmt
        run: terraform fmt -check
        continue-on-error: true
        
        
      - name: Terraform Init
        id: init
        run: terraform init  
        

      - name: Terraform Validate
        id: validate
        run: terraform validate -no-color
                
      
      - name: Terraform Plan
        id: plan
        run: terraform plan -no-color -input=false

         # 6. Terraform Apply (auto approve)
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'   # सिर्फ main branch पर apply होगा
      run: terraform apply -auto-approve tfplan
         
        
 
