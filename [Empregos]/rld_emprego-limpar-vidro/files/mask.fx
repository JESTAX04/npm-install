texture MainTexture;
texture MaskTexture;
texture FoamTexture;

float4 MainColor = float4(1, 1, 1, 1);
float4 MaskColor = float4(1, 1, 1, 0);

sampler SamplerTexture = sampler_state
{
	Texture = (MainTexture);
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler SamplerMask = sampler_state
{
	Texture = (MaskTexture);
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU	= Clamp;
	AddressV = Clamp;
};

sampler SamplerFoam = sampler_state
{
	Texture = (FoamTexture);
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU	= Clamp;
	AddressV = Clamp;
};

struct PSInput
{
	float2 TextureCoordinate : TEXCOORD0;
};

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float2 mainPosition = PS.TextureCoordinate.xy;

	float4 mainPixel = tex2D(SamplerTexture, mainPosition);
	float4 maskPixel = tex2D(SamplerMask, mainPosition);
	float4 foamPixel = tex2D(SamplerFoam, mainPosition);

	float4 finalColor = mainPixel + foamPixel;

	float4 color1 = MaskColor * maskPixel.r;
	float4 color2 = MainColor * (1 - maskPixel.r);

	finalColor *= (color1 + color2);

	return saturate(finalColor);
}

technique Mask
{
	pass P0
	{
		AlphaBlendEnable = true;
		SrcBlend = SrcAlpha;
		DestBlend = InvSrcAlpha;
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

technique Fallback
{
	pass P0
	{

	}
}
