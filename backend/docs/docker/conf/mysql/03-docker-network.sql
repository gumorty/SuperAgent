USE `ai-agent`;

UPDATE ai_api
SET api_base_url = 'http://one-api:3000'
WHERE api_base_url = 'http://localhost:3000';

UPDATE ai_mcp
SET mcp_param = JSON_SET(mcp_param, '$.baseUri', 'http://mcp-server-wecom:9002')
WHERE JSON_UNQUOTE(JSON_EXTRACT(mcp_param, '$.baseUri')) = 'http://127.0.0.1:9002';

UPDATE ai_mcp
SET mcp_param = JSON_SET(mcp_param, '$.baseUri', 'http://mcp-server-amap:9003')
WHERE JSON_UNQUOTE(JSON_EXTRACT(mcp_param, '$.baseUri')) = 'http://127.0.0.1:9003';

UPDATE ai_template
SET api_base_url = 'http://one-api:3000',
    snapshot = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(snapshot, 'http://localhost:3000', 'http://one-api:3000'),
                        'http://127.0.0.1:9001',
                        'http://mcp-server-csdn:9001'
                    ),
                    'http://127.0.0.1:9002',
                    'http://mcp-server-wecom:9002'
                ),
                'http://127.0.0.1:9003',
                'http://mcp-server-amap:9003'
            ),
            'http://127.0.0.1:9004',
            'http://mcp-server-email:9004'
        ),
        'http://127.0.0.1:9005',
        'http://mcp-server-bocha:9005'
    );
