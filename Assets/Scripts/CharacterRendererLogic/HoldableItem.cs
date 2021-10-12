using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.ServerAuthoritativeActions;


namespace CharacterRenderer
{
    public class HoldableItem : MonoBehaviour
    {
        public IKData iKData;
        

        public virtual void PlayPopAnimation()
        {
            gameObject.SetActive(true);
        }

        public virtual void PlayStowAnimation()
        {
            gameObject.SetActive(false);
        }

    }
}

