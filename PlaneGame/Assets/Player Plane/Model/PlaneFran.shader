Shader "Custom/PlaneFran"
{
    Properties
	{
		_BaseColor ("Base Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimColor ("Rim Color", Color) = (0.0, 0.0, 0.0, 1.0)
		_RimColorPower ("Rim Color Power", Float) = 0.1
	
		_HologramColor("Hologram Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_HologramTex ("Hologram Texture", 2D) = "defaulttexture" {}
		_ScrollSpeed ("Scroll Speed", Float) = 2
		
		_Tiling ("Tiling", Vector) = (1, 1, 1, 1)
		_Offset ("Offset", Vector) = (0, 0, 0, 0)
		_ModelTex ("Model Tex", 2D) = "defaulttexture" {}
		[Toggle]_Toggle ("Toggle", Int) = 0

		[Toggle]_IsEnemy("Is Enemy", Int) = 0
	}

	
	SubShader
	{
		
		CGPROGRAM


		#pragma surface surf Lambert


		struct Input 
		{
			float2 uv_HologramTex;
			float3 viewDir;
			float4 screenPos;
			float2 uv_ModelTex;
		};

		sampler2D _HologramTex;
		sampler2D _ModelTex;
		fixed4 _Tiling;
		fixed4 _Offset;
		
		fixed4 _BaseColor;
		fixed4 _RimColor;
		float _RimColorPower;

		fixed4 _HologramColor;
		float  _ScrollSpeed;
		float _Toggle;
		int _IsEnemy;

		void surf(Input IN, inout SurfaceOutput o)
		{
			
			fixed2 screenPos = IN.screenPos.xy / IN.screenPos.w;
			fixed2 tiling = _Tiling.xy * screenPos;
		    fixed2 offset = _Offset.xy + screenPos;

			fixed2 tuv = fixed2(IN.uv_HologramTex.x * tiling.x + offset.x, IN.uv_HologramTex.y * tiling.y + offset.y + (_ScrollSpeed * _Time.x));

			
			if (_Toggle == 1)
            {
				o.Albedo = tex2D(_HologramTex, tuv);
				float dotP = dot(IN.viewDir, o.Normal);
			
				float rimIntensity = pow(1 - dotP, _RimColorPower);
			
				fixed3 finalColor = lerp(_BaseColor.rgb, _RimColor.rgb, rimIntensity);

				o.Alpha = smoothstep(0.0, 0.9, rimIntensity);

				o.Emission = finalColor;
		            
			}
            else
            {
				o.Albedo = tex2D(_ModelTex,IN.uv_ModelTex);

				if(_IsEnemy){o.Albedo = 1-o.Albedo.rgb; }

				o.Alpha = 1;
			}
		}
	
		ENDCG
	}
}
