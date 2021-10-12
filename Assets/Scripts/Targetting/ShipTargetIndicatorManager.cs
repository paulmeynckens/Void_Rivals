using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CharacterRenderer;


namespace Targetting
{
    public class ShipTargetIndicatorManager : MonoBehaviour
    {
    // Start is called before the first frame update
        Target target;
        private void Awake()
        {
            target = GetComponent<Target>();
        }

        // Update is called once per frame
        void FixedUpdate()
        {
            target.enabled = !LocalPlayerIsOnThisShip();
        
        }

        bool LocalPlayerIsOnThisShip()
        {
            return CharacterInterpolate.localPlayerShip == transform;
        }
    }
}
