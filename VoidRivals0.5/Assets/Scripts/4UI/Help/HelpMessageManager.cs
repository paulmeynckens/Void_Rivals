using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using UnityEngine.UI;
using Core;

namespace UI.Help
{
    public class HelpMessageManager : NetworkBehaviour
    {
        [SerializeField] HelpTip[] m_helpTips = null;

        string m_helpMessage;

        private void Start()
        {
            foreach (HelpTip helpTip in m_helpTips)
            {
                m_helpMessage += helpTip.m_help + " : " + KeyBindings.Pairs[helpTip.m_action].ToString() + "\n";
            }
        }



        public override void OnStartAuthority()
        {
            base.OnStartAuthority();
            //UI_Manager.instance.DisplayHelpText(m_helpMessage);
        }

        public override void OnStopAuthority()
        {
            base.OnStopAuthority();
            //UI_Manager.instance.HideHelpText();
        }
    }
}



