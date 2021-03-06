float4x4 matWorld:WORLD;
float4x4 matView:VIEW;
float4x4 matProjection:PROJECTION;

struct VS_INPUT
{
	float4 pos:POSITION;
	float4 color:COLOR;
};

struct PS_INPUT
{
	float4 pos:SV_POSITION;
	float4 color:COLOR;
};

PS_INPUT VS(VS_INPUT input)
{
	PS_INPUT output=(PS_INPUT)0;
	
	float4x4 matViewProjection=mul(matView,matProjection);
	float4x4 matWorldViewProjection=mul(matWorld,matViewProjection);
	
	output.color = input.color;
	
	output.pos=mul(input.pos,matWorldViewProjection);
	return output;
}

float4 PS(PS_INPUT input):SV_TARGET
{
	return float4(input.color);
}

RasterizerState DisableCulling
{
    CullMode = NONE;
};

technique10 Render
{
	pass P0
	{
		SetVertexShader(CompileShader(vs_4_0, VS() ) );
		SetGeometryShader( NULL );
		SetPixelShader( CompileShader( ps_4_0,  PS() ) );
		SetRasterizerState(DisableCulling); 
	}
}