import React from 'react';
import styled from 'styled-components';
import { HEALTH_TOPICS } from '../config';

const TopicsContainer = styled.div`
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 1.5rem;
  color: white;
`;

const TopicsHeader = styled.div`
  text-align: center;
  margin-bottom: 1.5rem;
  
  h3 {
    margin: 0 0 0.5rem 0;
    font-size: 1.3rem;
    font-weight: 600;
  }
  
  p {
    margin: 0;
    font-size: 0.9rem;
    opacity: 0.8;
  }
`;

const TopicsGrid = styled.div`
  display: grid;
  gap: 1rem;
  grid-template-columns: 1fr;
`;

const TopicCard = styled.button`
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  padding: 1rem;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: left;
  
  &:hover {
    background: rgba(255, 255, 255, 0.2);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
  
  &:active {
    transform: translateY(0);
  }
`;

const TopicIcon = styled.div`
  font-size: 2rem;
  margin-bottom: 0.5rem;
`;

const TopicTitle = styled.h4`
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-weight: 600;
`;

const TopicDescription = styled.p`
  margin: 0;
  font-size: 0.85rem;
  opacity: 0.9;
  line-height: 1.4;
`;

const HealthTopics = ({ onTopicSelect }) => {
  const handleTopicClick = (topic) => {
    const randomQuestion = topic.sampleQuestions[Math.floor(Math.random() * topic.sampleQuestions.length)];
    onTopicSelect(randomQuestion);
  };

  return (
    <TopicsContainer>
      <TopicsHeader>
        <h3>Health Topics</h3>
        <p>Click on a topic to get started</p>
      </TopicsHeader>
      
      <TopicsGrid>
        {HEALTH_TOPICS.map((topic) => (
          <TopicCard
            key={topic.id}
            onClick={() => handleTopicClick(topic)}
          >
            <TopicIcon>{topic.icon}</TopicIcon>
            <TopicTitle>{topic.title}</TopicTitle>
            <TopicDescription>{topic.description}</TopicDescription>
          </TopicCard>
        ))}
      </TopicsGrid>
    </TopicsContainer>
  );
};

export default HealthTopics;