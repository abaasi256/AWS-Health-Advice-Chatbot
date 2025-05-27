import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, ConnectionPatch
import numpy as np

def create_aws_architecture():
    fig, ax = plt.subplots(1, 1, figsize=(16, 12))
    
    # AWS Color Palette
    aws_orange = '#FF9900'
    aws_blue = '#232F3E'
    aws_light_blue = '#4B92DB'
    aws_gray = '#F2F3F3'
    
    # Set background
    fig.patch.set_facecolor('white')
    ax.set_facecolor('white')
    
    # Define positions and create professional boxes
    # Frontend Layer
    frontend_box = FancyBboxPatch((1, 8), 4, 2, 
                                  boxstyle="round,pad=0.1", 
                                  facecolor=aws_gray, 
                                  edgecolor=aws_blue, 
                                  linewidth=2)
    ax.add_patch(frontend_box)
    ax.text(3, 9, 'Frontend\nReact Application', 
            ha='center', va='center', fontsize=12, fontweight='bold')
    
    # AWS Cloud Layer
    aws_cloud = FancyBboxPatch((7, 4), 8, 8, 
                               boxstyle="round,pad=0.2", 
                               facecolor='#E8F4FD', 
                               edgecolor=aws_orange, 
                               linewidth=3)
    ax.add_patch(aws_cloud)
    ax.text(11, 11.5, 'AWS Cloud', 
            ha='center', va='center', fontsize=16, fontweight='bold', color=aws_orange)
    
    # Add AWS services with proper positioning
    services = [
        {'name': 'Amazon Lex v2\nNLU Engine', 'pos': (8, 9), 'color': aws_light_blue},
        {'name': 'AWS Lambda\nhealth-advice-chatbot', 'pos': (12, 9), 'color': aws_orange},
        {'name': 'IAM Roles\nSecurity', 'pos': (8, 6), 'color': '#DD344C'},
        {'name': 'CloudWatch\nMonitoring', 'pos': (12, 6), 'color': '#759C3E'}
    ]
    
    for service in services:
        service_box = FancyBboxPatch((service['pos'][0]-0.8, service['pos'][1]-0.6), 
                                     1.6, 1.2, 
                                     boxstyle="round,pad=0.1", 
                                     facecolor='white', 
                                     edgecolor=service['color'], 
                                     linewidth=2)
        ax.add_patch(service_box)
        ax.text(service['pos'][0], service['pos'][1], service['name'], 
                ha='center', va='center', fontsize=10, fontweight='bold')
    
    # Infrastructure Layer
    infra_box = FancyBboxPatch((1, 1), 4, 2, 
                               boxstyle="round,pad=0.1", 
                               facecolor='#F0F0F0', 
                               edgecolor='#666666', 
                               linewidth=2)
    ax.add_patch(infra_box)
    ax.text(3, 2, 'Infrastructure\nTerraform IaC', 
            ha='center', va='center', fontsize=12, fontweight='bold')
    
    # Add professional arrows
    arrows = [
        ((5, 9), (7.2, 9)),      # Frontend to Lex
        ((8.8, 9), (11.2, 9)),   # Lex to Lambda
        ((12, 8.4), (12, 6.6)),  # Lambda to CloudWatch
        ((5, 2), (7.2, 6)),      # Terraform to IAM
        ((4.5, 2.5), (7.5, 8.5)) # Terraform to Lex
    ]
    
    for start, end in arrows:
        arrow = ConnectionPatch(start, end, "data", "data",
                                arrowstyle="->", shrinkA=5, shrinkB=5,
                                mutation_scale=20, fc=aws_blue, ec=aws_blue, linewidth=2)
        ax.add_patch(arrow)
    
    # Set limits and remove axes
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 13)
    ax.set_aspect('equal')
    ax.axis('off')
    
    # Add title
    plt.title('AWS Health Advice Chatbot - Architecture Overview', 
              fontsize=18, fontweight='bold', color=aws_blue, pad=20)
    
    plt.tight_layout()
    plt.savefig('aws_health_chatbot_architecture.png', dpi=300, bbox_inches='tight')
    print("Professional AWS architecture diagram saved as 'aws_health_chatbot_architecture.png'")

if __name__ == "__main__":
    create_aws_architecture()
