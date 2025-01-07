Shader "MotionVectorsCamera" {
    HLSLINCLUDE
        #include "Assets/RenderPipeline/OwlcatShaders/ShaderLibrary/Core.hlsl"
        #include "Assets/RenderPipeline/OwlcatShaders/ShaderLibrary/Input.hlsl"
    ENDHLSL

    Properties
    {

    }
    
    SubShader {
        Tags { "RenderPipeline" = "OwlcatPipeline"}
                
        Pass {
            Cull Off
            ZWrite Off
            ZTest Always

            HLSLPROGRAM

            #pragma vertex vertex
            #pragma fragment pixel

            float4x4 _PrevViewProj;
            
            struct v2p {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2p vertex(uint vtx : SV_VertexID) {
                v2p v2p;
                v2p.position = GetFullScreenTriangleVertexPosition(vtx);
                v2p.uv = GetFullScreenTriangleTexCoord(vtx);
                return v2p;
            }

            float2 pixel(v2p v2p) : SV_Target {
                float deviceDepth = SampleDepthTexture(v2p.uv);
                float4 positionWS = float4(ComputeWorldSpacePosition(v2p.uv, deviceDepth, UNITY_MATRIX_I_VP), 1.0);
                float4 previousCS = mul(_PrevViewProj, positionWS);
                float2 currentNDC = v2p.uv * 2 - 1;
                float2 previousNDC = previousCS.xy / previousCS.w;

#if UNITY_UV_STARTS_AT_TOP
                previousNDC.y = -previousNDC.y;
#endif

                float2 vel = (currentNDC - previousNDC) * 0.5; // [-1,1] to [-0.5,0.5]
                return vel < 1e-6 ? 0 : vel;
            }
            
            ENDHLSL
        }
    }
}


