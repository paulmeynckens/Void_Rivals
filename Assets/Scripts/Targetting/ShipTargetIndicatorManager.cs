using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CharacterLogic;


namespace Targetting
{
    public class ShipTargetIndicatorManager : MonoBehaviour
    {

        Transform ship;
        Target target;
        private void Awake()
        {
            ship = transform.parent;
            target = GetComponent<Target>();
        }

        // Update is called once per frame
        void FixedUpdate()
        {
            target.enabled = !LocalPlayerIsOnThisShip();
        
        }

        bool LocalPlayerIsOnThisShip()
        {
            return CharacterLocal.localCharacter!=null && CharacterLocal.localCharacter.transform.parent == ship;
        }
    }
}
