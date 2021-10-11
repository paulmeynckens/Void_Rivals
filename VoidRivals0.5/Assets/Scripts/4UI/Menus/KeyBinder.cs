using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Core;

namespace UI.Menus
{
    public class KeyBinder : MonoBehaviour
    {
        [SerializeField] TMP_Text m_buttonText = null;
        [SerializeField] Actions m_boundAction = Actions.forward;

        private void Start()
        {
            m_buttonText.text = KeyBindings.Pairs[m_boundAction].ToString();
            this.enabled = false;
        }

        private void OnEnable()
        {
            m_buttonText.text = "press a key";
        }

        private void OnGUI()
        {
            Event e = Event.current;
            if (e.isKey)
            {
                KeyBindings.Pairs[m_boundAction] = e.keyCode;
                m_buttonText.text = KeyBindings.Pairs[m_boundAction].ToString();
                PlayerPrefs.SetString(m_boundAction.ToString(), e.keyCode.ToString());
                this.enabled = false;

            }
        }
    }
}

