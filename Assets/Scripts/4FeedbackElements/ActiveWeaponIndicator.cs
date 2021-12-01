using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Guns;
using UnityEngine.UI;

namespace FeedbackElements
{
    public class ActiveWeaponIndicator : MonoBehaviour
    {
        [SerializeField] ShipGun shipGun=null;
        Image image;

        private void Awake()
        {
            image = GetComponent<Image>();
        }
        // Update is called once per frame
        void FixedUpdate()
        {
            if (shipGun.enabled)
            {
                image.color = Color.green;
            }
            else
            {
                image.color = Color.black;
            }

        }
    }
}
