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
            
            if (hole == null)
            {
                Destroy(gameObject);
                return;
            }
            
            float xzScale= Structure.ConvertDamageToRadius(hole.Damage);
            Vector3 scale = new Vector3(xzScale, xzScale,1) ;
            transform.localScale = scale; 

        
        }
    }
}
