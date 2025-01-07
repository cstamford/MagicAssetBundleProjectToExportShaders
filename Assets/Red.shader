Shader "Unlit/Red"
{
	Properties {}

	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4 vert (float4 vertex : POSITION) : SV_POSITION { return UnityObjectToClipPos(vertex); }
			float4 frag () : SV_Target { return float4(1, 0, 0, 1); }
			
			ENDCG
		}
	}
}
