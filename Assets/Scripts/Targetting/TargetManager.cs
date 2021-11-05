using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Targetting
{


    // classe de base pour tous les managers
    /// <summary>
    /// //pour creer un nouveau manager, creer une classe heritant de celle ci
    /// 
    /// </summary>


    public abstract class TargetManager : MonoBehaviour
    {

        /// <summary>
        /// target à gerer avec ce manager, un manager par target, une target par manager
        /// mais autant d'indicateur par target que necessaire.
        /// </summary>
        public TargetThomas target;

        void LateUpdate()
        {
            DrawIndicators();
        }

        public abstract void DrawIndicators();



        public void Update()
        {
            
        }
    }
}
