using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Holes;
using GeneralRendering;
using Mirror;

namespace ShipsRenderer
{
    public class HoleRendererSeparate : MonoBehaviour
    {
        
        private void Awake()
        {
            HoleSpawn holeSpawn=GetComponentInParent<HoleSpawn>();
            holeSpawn.OnHolePlaced += SeparateHoleRenderer;
        }

        

        void SeparateHoleRenderer(HoleSpot holeSpot)
        {
            Transform targetParent = LinkToRenderer.shipsRenderersLinks[holeSpot.holeGeneratorIdentity.transform];
            transform.parent = targetParent;

            transform.localPosition = holeSpot.localPosition;
            transform.localRotation = holeSpot.localRotation;
        }
    }
}
