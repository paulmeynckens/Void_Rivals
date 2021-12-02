using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShipsLogic
{
    public class ShipExternalHideWhenInactive : MonoBehaviour
    {
        [SerializeField] GameObject originShip = null;
        private void FixedUpdate()
        {
            if (!originShip.activeSelf)
            {
                transform.parent = originShip.transform;
                transform.localPosition = Vector3.zero;
                transform.localRotation = Quaternion.identity;

            }
        }
    }
}
