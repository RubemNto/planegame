Shader "Custom/Plane"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
        _MetalTex ("Metal)", 2D) = "white" {}
        _NormalTex ("Normal (RGB)", 2D) = "white" {}
        _GlossTex ("Gloss (RGB)", 2D) = "white" {}

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 1.0
        _Normal ("Normal", Range(0,1)) = 1.0

        _GreenOffset ("Green Offset",Range(0,1)) = 0
        _BlueOffset ("Blue Offset",Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalTex;
        sampler2D _GlossTex;
        sampler2D _MetalTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
            float2 uv_GlossTex;
            float2 uv_MetalTex;
        };

        half _Glossiness;
        half _Metallic;
        half _Normal;
        fixed4 _Color;
        float _GreenOffset;
        float _BlueOffset;
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            
            if(c.r - _GreenOffset > c.g && c.r - _BlueOffset> c.b) 
            {
                c *= _Color;
            }
            
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = tex2D (_MetalTex, IN.uv_MetalTex) * _Metallic;
            o.Smoothness = tex2D (_GlossTex, IN.uv_GlossTex) * _Glossiness;
            o.Normal = tex2D (_NormalTex, IN.uv_NormalTex) * _Normal;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
