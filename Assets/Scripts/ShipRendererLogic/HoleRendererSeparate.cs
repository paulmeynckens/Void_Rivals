using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Holes;
using GeneralRendering;

namespace ShipsRenderer
{
    public class HoleRendererSeparate : MonoBehaviour
    {
        
        private void Awake()
        {
            HoleSpawn holeSpawn=GetComponentInParent<HoleSpawn>();
            holeSpawn.OnHolePlaced += SeparateHoleRenderer;
        }


        void SeparateHoleRenderer()
        {
            Vector3 savedLocalPosition = transform.parent.localPosition;
            Quaternion savedLocalRotation = transform.parent.localRotation;

            transform.parent = LinkToRenderer.shipsRenderersLinks[transform.parent];

            transform.localPosition = savedLocalPosition;
            transform.localRotation = savedLocalRotation;
        }
    }
}
