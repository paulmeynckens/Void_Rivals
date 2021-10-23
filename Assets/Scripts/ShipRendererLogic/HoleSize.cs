using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Holes;

namespace ShipsRenderer
{
    public class HoleSize : MonoBehaviour
    {
        [SerializeField] Hole hole=null;
        

        // Update is called once per frame
        void Update()
        {
            float xzScale= Structure.ConvertDamageToRadius(hole.Damage);
            Vector3 scale = new Vector3(xzScale,0,xzScale) ;
            transform.localScale = scale; 

        
        }
    }
}
