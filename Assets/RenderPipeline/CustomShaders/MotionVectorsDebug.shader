Shader "MotionVectorsDebug" {
    HLSLINCLUDE
        #include "Assets/RenderPipeline/OwlcatShaders/ShaderLibrary/Core.hlsl"
        #include "Assets/RenderPipeline/OwlcatShaders/ShaderLibrary/Input.hlsl"
    ENDHLSL

    SubShader {
        Pass {
            Blend Off
            ZWrite Off
            ZTest Off

            HLSLPROGRAM
     
            #pragma vertex vertex
            #pragma fragment pixel

            TEXTURE2D(_MvecTexture);
            float _MinMotion;
            float _MaxMotion;
            float _ShowMovementOnly;
            float _VisualizationMode;

            SAMPLER(sampler_MvecTexture);
            
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

            float4 pixel(v2p v2p) : SV_Target {
                float2 motion = abs(SAMPLE_TEXTURE2D(_MvecTexture, sampler_MvecTexture, v2p.uv).xy);
                motion = (motion - _MinMotion) / (_MaxMotion - _MinMotion);
                float motionLen = length(motion);

                if (_ShowMovementOnly > 0.5f && motionLen < 1e-6) {
                    return 0;
                }
                
                if (_VisualizationMode == 0) {
                    return float4(motion, 0, 1);
                }
                
                return float4(motionLen.xxx, 1);
            }
            
            ENDHLSL
        }
    }
}
