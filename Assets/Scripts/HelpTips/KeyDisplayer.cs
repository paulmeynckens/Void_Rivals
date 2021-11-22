using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using TMPro;

namespace HelpTips
{
    public class KeyDisplayer : MonoBehaviour
    {
        [SerializeField] PlayerAction playerAction = PlayerAction.interact;

        TMP_Text mP_Text;
        private void Awake()
        {
            mP_Text = GetComponent<TMP_Text>();
        }

        private void OnEnable()
        {
            mP_Text.text = KeyBindings.Pairs[playerAction].ToString();
        }
    }
}
