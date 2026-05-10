USE `ai-agent`;

UPDATE ai_user
SET user_name = 'jianwei'
WHERE id = 1;

UPDATE ai_api
SET api_base_url = 'https://api.deepseek.com',
    api_completions_path = 'v1/chat/completions',
    api_embeddings_path = 'v1/embeddings'
WHERE api_id = 'api_deepseek_system';

INSERT INTO ai_api (api_id, api_base_url, api_key, api_completions_path, api_embeddings_path, api_from)
SELECT 'api_ollama_system',
       'https://ollama.506hpu.top',
       'ollama-local',
       'v1/chat/completions',
       'v1/embeddings',
       0
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_api
    WHERE api_id = 'api_ollama_system'
);

UPDATE ai_model
SET model_name = 'deepseek-v4-flash',
    model_type = 'DeepSeek'
WHERE model_id = 'model_DeepSeekChat_system';

INSERT INTO ai_model (model_id, api_id, model_name, model_type, model_from)
SELECT 'model_Gemma4_system',
       'api_ollama_system',
       'gemma4:26b',
       'Ollama',
       0
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_model
    WHERE model_id = 'model_Gemma4_system'
);

UPDATE ai_client
SET model_name = 'deepseek-v4-flash',
    client_name = 'DeepSeek Chat Client'
WHERE client_id = 'client_DeepSeekChat_system';

INSERT INTO ai_client (client_id, client_type, client_role, model_id, model_name, client_name, client_status, client_from)
SELECT 'client_Gemma4Chat_system',
       'chat',
       'chatclient',
       'model_Gemma4_system',
       'gemma4:26b',
       'Gemma Chat Client',
       1,
       0
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_client
    WHERE client_id = 'client_Gemma4Chat_system'
);

UPDATE ai_mcp
SET mcp_name = 'WeCom',
    mcp_param = '{"baseUri":"http://mcp-server-wecom:9002","sseEndPoint":"/sse"}',
    mcp_desc = 'Send enterprise WeCom application messages',
    mcp_from = 0
WHERE mcp_id = 'mcp_1_1773ZKbh';

UPDATE ai_mcp
SET mcp_name = 'Amap Weather',
    mcp_param = '{"baseUri":"http://mcp-server-amap:9003","sseEndPoint":"/sse"}',
    mcp_desc = 'Query weather data from the Amap API',
    mcp_from = 0
WHERE mcp_id = 'mcp_1_17731t1V';

INSERT INTO ai_mcp (mcp_id, mcp_name, mcp_type, mcp_param, mcp_secret, mcp_desc, mcp_timeout, mcp_from)
SELECT 'mcp_system_email',
       'Email',
       'sse',
       '{"baseUri":"http://mcp-server-email:9004","sseEndPoint":"/sse"}',
       '{"smtpHost":"","smtpPort":"","smtpUsername":"","smtpPassword":"","fromAddress":"","fromName":""}',
       'Send email through the Email MCP server',
       180,
       0
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_mcp
    WHERE mcp_id = 'mcp_system_email'
);

INSERT INTO ai_mcp (mcp_id, mcp_name, mcp_type, mcp_param, mcp_secret, mcp_desc, mcp_timeout, mcp_from)
SELECT 'mcp_system_bocha',
       'Bocha Search',
       'sse',
       '{"baseUri":"http://mcp-server-bocha:9005","sseEndPoint":"/sse"}',
       '{"apiKey":""}',
       'Run web search through the Bocha MCP server',
       180,
       0
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_mcp
    WHERE mcp_id = 'mcp_system_bocha'
);

INSERT INTO ai_mcp (mcp_id, mcp_name, mcp_type, mcp_param, mcp_secret, mcp_desc, mcp_timeout, mcp_from)
SELECT 'mcp_system_csdn',
       'CSDN Publisher',
       'sse',
       '{"baseUri":"http://mcp-server-csdn:9001","sseEndPoint":"/sse"}',
       '{"cookie":"","categories":"","tags":"","coverUrl":""}',
       'Publish markdown articles to CSDN through the MCP server',
       180,
       0
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_mcp
    WHERE mcp_id = 'mcp_system_csdn'
);
