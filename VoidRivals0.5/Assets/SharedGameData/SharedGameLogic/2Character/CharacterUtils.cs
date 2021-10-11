using UnityEngine;
using System.Collections;

namespace CharacterLogic
{
    public struct CharacterData
    {
        public bool isMale;
    }

    public interface ICanSit
    {
        void SitHere(Transform p_rightHandGrip, Transform p_leftHandGrip, Transform p_newheadPointer, Transform p_sittingPosition, bool p_needSitting);
        void GetUp();
    }
}