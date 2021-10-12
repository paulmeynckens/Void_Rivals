using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RoundManagement;
using Mirror;
using System;

namespace CharacterRenderer
{
    public class CharacterApparence : MonoBehaviour
    {

        [SerializeField] Material blueMaterial = null;
        [SerializeField] Material redMaterial = null;
        [SerializeField] List<Renderer> teamColorRenderers = null;
        [SerializeField] List<GameObject> maleBody = null;
        [SerializeField] List<GameObject> femaleBody = null;
        [SerializeField] TextMesh m_textMesh = null;

        [SerializeField] Renderer[] headsRenderers = null;


        private void Awake()
        {
            LinkToNetId linkToNetId = GetComponentInParent<LinkToNetId>();
            if (linkToNetId != null)
            {
                linkToNetId.OnClientLinkEstablished += SearchPawnAndSetApparence;
            }

        }
        void SearchPawnAndSetApparence(uint targetId)
        {
            PlayerPawn playerPawn = NetworkIdentity.spawned[targetId].GetComponent<PlayerPawn>();

            SetColor(playerPawn.Crew.team);
            SetGender(playerPawn.playerData.characterData.isMale);
            SetName(playerPawn.playerData.playerName);
            if (playerPawn.isLocalPlayer)
            {
                HideHead();
            }

        }

        private void HideHead()
        {
            foreach(Renderer renderer in headsRenderers)
            {
                renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
            }
        }

        public void SetColor( bool color)
        {
            foreach (Renderer renderer in teamColorRenderers)
            {
                switch (color)
                {
                    case true:

                        renderer.material = blueMaterial;
                        break;

                    case false:
                        renderer.material = redMaterial;
                        break;
                }
            }
        }



        public void SetGender(bool isMale)
        {
            foreach (GameObject malePart in maleBody)
            {
                malePart.SetActive(isMale);

            }
            foreach (GameObject femalePart in femaleBody)
            {
                femalePart.SetActive(!isMale); ;
            }
        }



        public void SetName(string playerName)
        {
            gameObject.name = playerName;
            m_textMesh.text = playerName;
        }







    }
}

