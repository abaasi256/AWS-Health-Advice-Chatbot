import React, { useState } from 'react';
import styled from 'styled-components';
import ChatInterface from './components/ChatInterface';
import HealthTopics from './components/HealthTopics';
import { APP_CONFIG } from './config';

const AppContainer = styled.div`
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 2rem 1rem;
`;

const MainContent = styled.div`
  max-width: 1200px;
  margin: 0 auto;
`;

const Header = styled.header`
  text-align: center;
  margin-bottom: 3rem;
`;

const Title = styled.h1`
  font-size: 2.5rem;
  font-weight: 700;
  color: white;
  margin-bottom: 0.5rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  
  @media (max-width: 768px) {
    font-size: 2rem;
  }
`;

const Subtitle = styled.p`
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 1rem;
  
  @media (max-width: 768px) {
    font-size: 1rem;
  }
`;

const FeatureBadges = styled.div`
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
  margin-top: 1rem;
`;

const Badge = styled.span`
  background: rgba(255, 255, 255, 0.2);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 25px;
  font-size: 0.875rem;
  font-weight: 500;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
`;

const ChatSection = styled.section`
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
  
  @media (min-width: 1024px) {
    grid-template-columns: 1fr 400px;
  }
`;

const ChatWrapper = styled.div`
  order: 2;
  
  @media (min-width: 1024px) {
    order: 1;
  }
`;

const TopicsWrapper = styled.div`
  order: 1;
  
  @media (min-width: 1024px) {
    order: 2;
  }
`;

const Footer = styled.footer`
  margin-top: 3rem;
  text-align: center;
  color: rgba(255, 255, 255, 0.8);
`;

const DisclaimerCard = styled.div`
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1rem;
  color: white;
`;

const DisclaimerTitle = styled.h3`
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 0.75rem;
  color: #fbbf24;
  display: flex;
  align-items: center;
  gap: 0.5rem;
`;

const DisclaimerText = styled.p`
  font-size: 0.9rem;
  line-height: 1.6;
  margin: 0;
  opacity: 0.9;
`;

const TechStack = styled.div`
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
  margin-top: 1rem;
`;

const TechBadge = styled.span`
  background: rgba(255, 255, 255, 0.1);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.75rem;
  font-weight: 500;
`;

function App() {
  const [selectedMessage, setSelectedMessage] = useState('');

  const handleTopicSelect = (message) => {
    setSelectedMessage(message);
  };

  const handleMessageSent = (message) => {
    console.log('Message sent:', message);
  };

  return (
    <AppContainer>
      <MainContent>
        <Header>
          <Title>{APP_CONFIG.name}</Title>
          <Subtitle>{APP_CONFIG.description}</Subtitle>
          
          <FeatureBadges>
            <Badge>🤖 AI-Powered</Badge>
            <Badge>🎤 Voice Support</Badge>
            <Badge>☁️ AWS Lex</Badge>
            <Badge>❤️ Health Focus</Badge>
          </FeatureBadges>
        </Header>

        <DisclaimerCard>
          <DisclaimerTitle>
            ⚠️ Important Health Disclaimer
          </DisclaimerTitle>
          <DisclaimerText>
            This chatbot provides general health information for educational purposes only. 
            It is not a substitute for professional medical advice, diagnosis, or treatment. 
            Always consult with qualified healthcare providers for personalized medical guidance.
          </DisclaimerText>
        </DisclaimerCard>

        <ChatSection>
          <TopicsWrapper>
            <HealthTopics onTopicSelect={handleTopicSelect} />
          </TopicsWrapper>
          
          <ChatWrapper>
            <ChatInterface
              onMessageSent={handleMessageSent}
              initialMessage={selectedMessage}
              key={selectedMessage}
            />
          </ChatWrapper>
        </ChatSection>

        <Footer>
          <DisclaimerCard>
            <DisclaimerTitle>
              💻 Built with Modern Technologies
            </DisclaimerTitle>
            <TechStack>
              <TechBadge>React 18</TechBadge>
              <TechBadge>AWS Lex v2</TechBadge>
              <TechBadge>Lambda</TechBadge>
              <TechBadge>Terraform</TechBadge>
              <TechBadge>Voice API</TechBadge>
              <TechBadge>Styled Components</TechBadge>
            </TechStack>
            <DisclaimerText style={{ marginTop: '1rem' }}>
              Portfolio project demonstrating full-stack AWS development with modern frontend technologies.
              <br />
              <strong>Version:</strong> {APP_CONFIG.version} | 
              <strong> Region:</strong> {process.env.REACT_APP_AWS_REGION || 'us-east-1'}
            </DisclaimerText>
          </DisclaimerCard>
        </Footer>
      </MainContent>
    </AppContainer>
  );
}

export default App;