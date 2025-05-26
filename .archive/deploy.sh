#!/bin/bash

# Automated deployment script for Lambda integration
echo "🚀 Starting Lambda Integration Deployment"
echo "=========================================="

cd /Users/abaasi/Desktop/AWS-Health-Advice-Chatbot/infra

# Step 1: Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init > /tmp/terraform_init.log 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Terraform initialization successful"
else
    echo "❌ Terraform initialization failed"
    cat /tmp/terraform_init.log
    exit 1
fi

# Step 2: Validate configuration
echo "📋 Validating Terraform configuration..."
terraform validate > /tmp/terraform_validate.log 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Terraform validation successful"
else
    echo "❌ Terraform validation failed"
    cat /tmp/terraform_validate.log
    exit 1
fi

# Step 3: Plan deployment
echo "📊 Planning Terraform deployment..."
terraform plan -out=tfplan > /tmp/terraform_plan.log 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Terraform plan successful"
else
    echo "❌ Terraform plan failed"
    cat /tmp/terraform_plan.log
    exit 1
fi

# Step 4: Apply deployment
echo "🚀 Applying Terraform deployment..."
terraform apply tfplan > /tmp/terraform_apply.log 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Terraform apply successful"
    
    # Get outputs
    echo "📋 Deployment Summary:"
    terraform output deployment_summary
    
    echo ""
    echo "🎉 Lambda integration deployment completed successfully!"
    echo ""
    echo "🧪 Next steps:"
    echo "1. Test the bot in AWS Console"
    echo "2. Use the TestBotAlias for Lambda fulfillment"
    echo "3. Try phrases like 'Give me sleep advice'"
    
else
    echo "❌ Terraform apply failed"
    cat /tmp/terraform_apply.log
    exit 1
fi
