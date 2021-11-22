using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace UI.Help
{
    [CreateAssetMenu(fileName = "Help Tip", menuName = "Help Tip")]
    public class HelpTip : ScriptableObject
    {
        public string m_help = "action";

        public PlayerAction m_action;
    }
}


