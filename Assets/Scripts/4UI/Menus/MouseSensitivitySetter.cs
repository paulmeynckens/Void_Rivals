using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using UnityEngine.UI;


namespace UI
{
    public class MouseSensitivitySetter : MonoBehaviour
    {
        Slider slider;
        private void Start()
        {
            slider = GetComponent<Slider>();
            KeyBindings.m_mouseSensitivity = PlayerPrefs.GetFloat("Mouse sensitivity", 1);
            slider.value = KeyBindings.m_mouseSensitivity;
        }

        // Update is called once per frame
        void Update()
        {
            KeyBindings.m_mouseSensitivity = slider.value;
            PlayerPrefs.SetFloat("Mouse sensitivity", KeyBindings.m_mouseSensitivity);
        }


    }
}
