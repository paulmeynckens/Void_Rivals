using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Dissonance;
using TMPro;
using RoundManagement;

namespace UI.Chat
{
    public class PlayerSpeakingIndicator : MonoBehaviour
    {
        [SerializeField] TMP_Text playerNameText = null;
        [SerializeField] GameObject playerTag = null;
        [SerializeField] Transform speechIntensityIndicator = null;

        PlayerPawn playerPawn;



        private float _intensity;

        private IDissonancePlayer _player;
        private VoicePlayerState _state;


        private void Awake()
        {
            playerPawn = transform.root.GetComponent<PlayerPawn>();
            _player = transform.root.GetComponent<IDissonancePlayer>();

        }

        private bool IsSpeaking
        {
            get { return _player.Type == NetworkPlayerType.Remote && _state != null && _state.IsSpeaking; }
        }

        // Start is called before the first frame update
        void Start()
        {
            StartCoroutine(FindPlayerState());
            playerTag.transform.parent = FindObjectOfType<VoiceChatPannel>().transform;
            playerTag.transform.localScale = Vector3.one;
            playerTag.transform.localRotation = Quaternion.identity;

            
        }

        private IEnumerator FindPlayerState()
        {
            
            //Wait until player tracking has initialized
            while (!_player.IsTracking)
                yield return null;

            //Now ask Dissonance for the object which represents the state of this player
            //The loop is necessary in case Dissonance is still initializing this player into the network session
            while (_state == null)
            {
                _state = FindObjectOfType<DissonanceComms>().FindPlayer(_player.PlayerId);
                playerNameText.text = playerPawn.PlayerData.playerName;

                yield return null;
            }
        }

        // Update is called once per frame
        void Update()
        {

            if (playerPawn == null)
            {
                Destroy(playerTag);
                Destroy(gameObject);
            }
            playerTag.SetActive(IsSpeaking);

            if (IsSpeaking)
            {
                //to be optimised

                _intensity = Mathf.Max(Mathf.Clamp(Mathf.Pow(_state.Amplitude, 0.175f), 0.25f, 1), _intensity - Time.unscaledDeltaTime);
                speechIntensityIndicator.localScale = new Vector3(_intensity, _intensity, _intensity);
            }
           

        
        }
    }
}
