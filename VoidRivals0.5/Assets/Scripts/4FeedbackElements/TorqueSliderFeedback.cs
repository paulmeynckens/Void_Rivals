using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using ShipsLogic;

namespace FeedbackElements
{
    public class TorqueSliderFeedback : MonoBehaviour
    {
        [SerializeField] Slider yawSlider = null;
        [SerializeField] Slider pitchSlider = null;

        ShipController shipController;


        private void Awake()
        {
            shipController = GetComponentInParent<ShipController>();
        }

        private void FixedUpdate()
        {
            yawSlider.value = (shipController.CurrentInputSnapshot.yaw / shipController.shipData.yawTorque);
            pitchSlider.value = (shipController.CurrentInputSnapshot.pitch / shipController.shipData.pitchTorque);
        }
    }
}

