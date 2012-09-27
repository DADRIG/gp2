/************* UN-TWEAKABLES **************/

float4x4 matWorld:WORLD;
float4x4 matView:VIEW;
float4x4 matProjection:PROJECTION;


/*********** Tweakables **********************/
struct VS_INPUT
{
	float4 pos:POSITION;
};



struct PS_INPUT
{
	float4 pos:SV_POSITION;
};

PS_INPUT VS(VS_INPUT input)
{
	PS_INPUT output=(PS_INPUT)0;
	
	float4x4 matViewProjection=mul(matView,matProjection);
	float4x4 matWorldViewProjection=mul(matWorld,matViewProjection);
	
	output.pos=mul(input.pos,matWorldViewProjection);
	return output;
}

float4 PS(PS_INPUT input):SV_TARGET
{
	return float4(1.0f,1.0f,1.0f,1.0f);
}

RasterizerState DisableCulling;
{
	CullMode = NONE;
};

technique10 Render
{
	passP0
	{
		SetVertexShader(CompileShader(vs_4_0,VS()));
		SetGeometryShader(NULL);
		SetPixelShader(CompileShader(ps_4_0,PS()));
		SetRasterizerState(DisableCulling);
	}
}




float3 LightPos : Position <
	string Object = "PointLight0";
	string Space = "World";
> = {10.0f, 10.0f, -10.0f};

/////

float3 AmbiColor : Ambient <
	string UIName =  "Ambient Lighting";
	string UIWidget = "Color";
> = {0.1f, 0.1f, 0.1f};

/////

float3 SurfColor : DIFFUSE <
	string UIName =  "Surface Color";
	string UIWidget = "Color";
> = {0.8f, 0.8f, 1.0f};

float Ks <
	string UIWidget = "slider";
	float UIMin = 0.0;
	float UIMax = 1.0;
	float UIStep = 0.01;
	string UIName =  "Specular Intensity";
> = 0.5;

float SpecExpon : SpecularPower <
	string UIWidget = "slider";
	float UIMin = 1.0;
	float UIMax = 128.0;
	float UIStep = 1.0;
	string UIName =  "Specular Power";
> = 30.0;

/************* DATA STRUCTS **************/

/* data from application vertex buffer */
struct appdata {
	float3 Position	: POSITION;
	float4 UV		: TEXCOORD0;
	float4 Normal	: NORMAL0;
};

/* data passed from vertex shader to pixel shader */
struct vertexOutput {
	float4 HPosition	: POSITION;
	float2 UV		: TEXCOORD0;
	float3 LightVec	: TEXCOORD1;
	float3 WorldNormal	: TEXCOORD2;
	float3 WorldEyeVec	: TEXCOORD3;
};

/*********** vertex shader ******/

vertexOutput simpleVS(appdata IN) {
	vertexOutput OUT = (vertexOutput)0;
	OUT.WorldNormal = mul(IN.Normal, WorldITXf).xyz;
	float4 Po = float4(IN.Position.xyz,1);
	float3 Pw = mul(Po, WorldXf).xyz;
	OUT.LightVec = (LightPos - Pw);
	OUT.WorldEyeVec = (ViewIXf[3].xyz - Pw);
	OUT.HPosition = mul(Po, WvpXf);
	OUT.UV = IN.UV.xy;
	return OUT;
}

/********* pixel shader ********/

float4 simplePS(vertexOutput IN) : COLOR {
	float3 Ln = normalize(IN.LightVec);
	float3 Vn = normalize(IN.WorldEyeVec);
	float3 Nn = normalize(IN.WorldNormal);
	float3 Hn = normalize(Vn + Ln);
	float4 lv = lit(dot(Ln,Nn),dot(Hn,Nn),SpecExpon);
	float3 DiffResult = SurfColor * (lv.yyy + AmbiColor);
	float3 SpecResult = Ks * lv.zzz;
	return float4((DiffResult + SpecResult).xyz,1.0);
}

/*************/

technique main
{
	pass p0
	{
		VertexShader = compile vs_2_a simpleVS();
		PixelShader = compile ps_2_a simplePS();
		ZEnable = true;
		ZWriteEnable = true;		
		CullMode=None; 
	}
}

/***************************** eof ***/
