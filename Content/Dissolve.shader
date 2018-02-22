Shader "Custom/Dissolve" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_EdgeColor ("Edge Color", Color) = (1,1,1,1)

		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_Noise ("Noise", 2D) = "white" {}

	//	_Dissolve ("Dissolve", Range(0, 1)) = 0.5 // This is set in the script 
		_EdgeThreshold ("Edge", Range (0, 0.25)) = 0
		_SecondEdgeThreshold ("Second Edge", Range (0, 0.25)) = 0

		[MaterialToggle] _Invert("Invert", Float) = 0
	}
	SubShader {
		Tags 
    	{
        	"Queue"="Transparent" 
        	"RenderType"="Transparent" 
		}
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Noise;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Noise;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _EdgeColor;
		float _EdgeThreshold;
		bool _Invert;

		uniform float _Dissolve; //Set in script

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 noiseSample = tex2D(_Noise, IN.uv_Noise);
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			
			float firstBorder;
			bool isBorder;

			if (_Invert)
			{
				firstBorder = _Dissolve - _EdgeThreshold;
				isBorder = noiseSample > firstBorder;
			}
			else
			{
				firstBorder = _Dissolve + _EdgeThreshold;
				isBorder = noiseSample < firstBorder;
			}

			if (isBorder)
			{
				o.Albedo = _EdgeColor;
			}
			else
			{
				o.Albedo = c.rgb;
			}

			//o.Albedo = noiseSample > _Dissolve ? 1 : 0;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			if (_Invert)
			{
				o.Alpha = noiseSample < _Dissolve;
			} 
			else
			{
				o.Alpha = noiseSample > _Dissolve;
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
