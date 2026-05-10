USE `ai-agent`;

UPDATE ai_api
SET api_base_url = 'http://one-api:3000'
WHERE api_id = 'api_deepseek_system';

UPDATE ai_model
SET model_name = 'deepseek-v4-flash',
    model_type = 'DeepSeek'
WHERE model_id = 'model_DeepSeekChat_system';

UPDATE ai_client
SET model_name = 'deepseek-v4-flash',
    client_name = 'Chat Client - DeepSeek'
WHERE client_id = 'client_DeepSeekChat_system';

UPDATE ai_mcp
SET mcp_name = 'WeCom',
    mcp_desc = 'Send enterprise WeCom application messages'
WHERE mcp_id = 'mcp_1_1773ZKbh';

UPDATE ai_mcp
SET mcp_name = 'Amap Weather',
    mcp_desc = 'Query weather data from the Amap API'
WHERE mcp_id = 'mcp_1_17731t1V';

UPDATE ai_template
SET agent_name = 'Web Search Agent',
    agent_desc = 'Search the web and summarize current information',
    api_base_url = 'http://one-api:3000',
    model_name = 'deepseek-v4-flash',
    model_type = 'DeepSeek'
WHERE template_id = 'template_agent_web';

UPDATE ai_template
SET agent_name = 'Article Publishing Agent',
    agent_desc = 'Organize content and prepare article publishing workflows',
    api_base_url = 'http://one-api:3000',
    model_name = 'deepseek-v4-flash',
    model_type = 'DeepSeek'
WHERE template_id = 'template_agent_article';

UPDATE ai_template
SET agent_name = 'Weather Broadcast Agent',
    agent_desc = 'Query weather data and prepare broadcast-friendly summaries',
    api_base_url = 'http://one-api:3000',
    model_name = 'deepseek-v4-flash',
    model_type = 'DeepSeek'
WHERE template_id = 'template_agent_weather';

UPDATE ai_plaza
SET plaza_title = 'Web Search Agent',
    plaza_desc = 'Suitable for real-time web search, fact checking, and summary output',
    agent_name = 'Web Search Agent'
WHERE plaza_id = 'plaza_agent_web';

UPDATE ai_plaza
SET plaza_title = 'Article Publishing Agent',
    plaza_desc = 'Suitable for content organization, article publishing, and delivery workflows',
    agent_name = 'Article Publishing Agent'
WHERE plaza_id = 'plaza_agent_article';

UPDATE ai_plaza
SET plaza_title = 'Weather Broadcast Agent',
    plaza_desc = 'Suitable for weather queries, result processing, and multi-channel delivery',
    agent_name = 'Weather Broadcast Agent'
WHERE plaza_id = 'plaza_agent_weather';
