Shader "HolePunch" {

	SubShader{

		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType" = "Transparent"
			"Queue" = "Geometry+1"
		}

		// Don't draw in the RGBA channels; just the stencil buffer

		ColorMask 0
		ZWrite Off
		Stencil {

		Ref 2
		Comp Always
		Pass Replace

		}

		// Do nothing specific in the pass:

		Pass {}
	}
}